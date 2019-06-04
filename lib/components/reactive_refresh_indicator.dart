// Copyright 2014 The Chromium Authors. All rights reserved.

// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:

//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above
//       copyright notice, this list of conditions and the following
//       disclaimer in the documentation and/or other materials provided
//       with the distribution.
//     * Neither the name of Google Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// from https://gist.github.com/kentcb/d5afd520a0027d1d2698fa943eea4566

// The over-scroll distance that moves the indicator to its maximum displacement, as a percentage of the scrollable's container extent.
const double _kDragContainerExtentPercentage = 0.25;

// How much the scroll's drag gesture can overshoot the RefreshIndicator's displacement; max displacement = _kDragSizeFactorLimit * displacement.
const double _kDragSizeFactorLimit = 1.5;

// When the scroll ends, the duration of the refresh indicator's animation to the RefreshIndicator's displacement.
const Duration _kIndicatorSnapDuration = const Duration(milliseconds: 150);

// The duration of the ScaleTransition that starts when the refresh action has completed.
const Duration _kIndicatorScaleDuration = const Duration(milliseconds: 200);

/// The signature for a function that's called when the user has dragged a [ReactiveRefreshIndicator] far enough to demonstrate that they want to
/// instigate a refresh.
typedef void RefreshCallback();

// The state machine moves through these modes only when the scrollable identified by scrollableKey has been scrolled to its min or max limit.
enum _RefreshIndicatorMode {
  drag, // Pointer is down.
  armed, // Dragged far enough that an up event will run the onRefresh callback.
  snap, // Animating to the indicator's final "displacement".
  refresh, // Running the refresh callback.
  done, // Animating the indicator's fade-out after refreshing.
  canceled, // Animating the indicator's fade-out after not arming.
}

/// This is a customization of the [RefreshIndicator] widget that is reactive in design. This makes it much easier to integrate into code
/// that has multiple avenues of refresh instigation. That is, refreshing in response to the user pulling down a [ListView], but also in
/// response to some other stimuli, like swiping a header left or right.
///
/// Instead of [onRefresh] being asynchronous as it is in [RefreshIndicator], it is synchronous. Consequently, instead of determining the
/// visibility of the refresh indicator on your behalf, you must tell the control yourself via [isRefreshing]. The [onRefresh] callback is
/// only executed if the user instigates a refresh via a pull-to-refresh gesture.
class ReactiveRefreshIndicator extends StatefulWidget {
  const ReactiveRefreshIndicator({
    Key key,
    @required this.child,
    this.displacement: 40.0,
    @required this.isRefreshing,
    @required this.onRefresh,
    this.color,
    this.backgroundColor,
    this.notificationPredicate: defaultScrollNotificationPredicate,
  })  : assert(child != null),
        assert(onRefresh != null),
        assert(notificationPredicate != null),
        assert(isRefreshing != null),
        super(key: key);

  final Widget child;

  final double displacement;

  final bool isRefreshing;

  final RefreshCallback onRefresh;

  final Color color;

  final Color backgroundColor;

  final ScrollNotificationPredicate notificationPredicate;

  @override
  ReactiveRefreshIndicatorState createState() =>
      new ReactiveRefreshIndicatorState();
}

class ReactiveRefreshIndicatorState extends State<ReactiveRefreshIndicator>
    with TickerProviderStateMixin {
  AnimationController _positionController;
  AnimationController _scaleController;
  Animation<double> _positionFactor;
  Animation<double> _scaleFactor;
  Animation<double> _value;
  Animation<Color> _valueColor;

  _RefreshIndicatorMode _mode;
  bool _isIndicatorAtTop;
  double _dragOffset;

  @override
  void initState() {
    super.initState();

    _positionController = new AnimationController(vsync: this);
    _positionFactor = new Tween<double>(
      begin: 0.0,
      end: _kDragSizeFactorLimit,
    ).animate(_positionController);
    _value = new Tween<double>(
      // The "value" of the circular progress indicator during a drag.
      begin: 0.0,
      end: 0.75,
    ).animate(_positionController);

    _scaleController = new AnimationController(vsync: this);
    _scaleFactor = new Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(_scaleController);
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    _valueColor = new ColorTween(
            begin: (widget.color ?? theme.accentColor).withOpacity(0.0),
            end: (widget.color ?? theme.accentColor).withOpacity(1.0))
        .animate(new CurvedAnimation(
            parent: _positionController,
            curve: const Interval(0.0, 1.0 / _kDragSizeFactorLimit)));

    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(ReactiveRefreshIndicator oldWidget) {
    if (widget.isRefreshing) {
      if (_mode != _RefreshIndicatorMode.refresh) {
        // Doing this work immediately triggers an assertion failure in the case when the refresh indicator is visible
        // upon first display:
        //
        //    I/flutter (21441): The following assertion was thrown building ReactiveRefreshIndicator(state:
        //    I/flutter (21441): ReactiveRefreshIndicatorState#26328(tickers: tracking 2 tickers)):
        //    I/flutter (21441): 'package:flutter/src/rendering/object.dart': Failed assertion: line 1792 pos 12: '() {
        //    I/flutter (21441):       final AbstractNode parent = this.parent;
        //    I/flutter (21441):       if (parent is RenderObject)
        //    I/flutter (21441):         return parent._needsCompositing;
        //    I/flutter (21441):       return true;
        //    I/flutter (21441):     }()': is not true.
        //
        // Therefore, we schedule it via a future instead.

        new Future(() {
          _start(AxisDirection.down);
          _show();
        });
      }
    } else {
      if (_mode != null && _mode != _RefreshIndicatorMode.done) {
        _dismiss(_RefreshIndicatorMode.done);
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _positionController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (!widget.notificationPredicate(notification)) {
      return false;
    }

    if (notification is ScrollStartNotification &&
        notification.metrics.extentBefore == 0.0 &&
        _mode == null &&
        _start(notification.metrics.axisDirection)) {
      setState(() {
        _mode = _RefreshIndicatorMode.drag;
      });
      return false;
    }

    bool indicatorAtTopNow;

    switch (notification.metrics.axisDirection) {
      case AxisDirection.down:
        indicatorAtTopNow = true;
        break;
      case AxisDirection.up:
        indicatorAtTopNow = false;
        break;
      case AxisDirection.left:
      case AxisDirection.right:
        indicatorAtTopNow = null;
        break;
    }

    if (indicatorAtTopNow != _isIndicatorAtTop) {
      if (_mode == _RefreshIndicatorMode.drag ||
          _mode == _RefreshIndicatorMode.armed) {
        _dismiss(_RefreshIndicatorMode.canceled);
      }
    } else if (notification is ScrollUpdateNotification) {
      if (_mode == _RefreshIndicatorMode.drag ||
          _mode == _RefreshIndicatorMode.armed) {
        if (notification.metrics.extentBefore > 0.0) {
          _dismiss(_RefreshIndicatorMode.canceled);
        } else {
          _dragOffset -= notification.scrollDelta;
          _checkDragOffset(notification.metrics.viewportDimension);
        }
      }
    } else if (notification is OverscrollNotification) {
      if (_mode == _RefreshIndicatorMode.drag ||
          _mode == _RefreshIndicatorMode.armed) {
        _dragOffset -= notification.overscroll / 2.0;
        _checkDragOffset(notification.metrics.viewportDimension);
      }
    } else if (notification is ScrollEndNotification) {
      switch (_mode) {
        case _RefreshIndicatorMode.armed:
          _show();
          break;
        case _RefreshIndicatorMode.drag:
          _dismiss(_RefreshIndicatorMode.canceled);
          break;
        default:
          // do nothing
          break;
      }
    }

    return false;
  }

  bool _handleGlowNotification(OverscrollIndicatorNotification notification) {
    if (notification.depth != 0 || !notification.leading) {
      return false;
    }

    if (_mode == _RefreshIndicatorMode.drag) {
      notification.disallowGlow();
      return true;
    }

    return false;
  }

  bool _start(AxisDirection direction) {
    assert(_mode == null);
    assert(_isIndicatorAtTop == null);
    assert(_dragOffset == null);

    switch (direction) {
      case AxisDirection.down:
        _isIndicatorAtTop = true;
        break;
      case AxisDirection.up:
        _isIndicatorAtTop = false;
        break;
      case AxisDirection.left:
      case AxisDirection.right:
        _isIndicatorAtTop = null;
        // we do not support horizontal scroll views.
        return false;
    }

    _dragOffset = 0.0;
    _scaleController.value = 0.0;
    _positionController.value = 0.0;

    return true;
  }

  void _checkDragOffset(double containerExtent) {
    assert(_mode == _RefreshIndicatorMode.drag ||
        _mode == _RefreshIndicatorMode.armed);

    double newValue =
        _dragOffset / (containerExtent * _kDragContainerExtentPercentage);

    if (_mode == _RefreshIndicatorMode.armed) {
      newValue = math.max(newValue, 1.0 / _kDragSizeFactorLimit);
    }

    _positionController.value =
        newValue.clamp(0.0, 1.0); // this triggers various rebuilds

    if (_mode == _RefreshIndicatorMode.drag &&
        _valueColor.value.alpha == 0xFF) {
      _mode = _RefreshIndicatorMode.armed;
    }
  }

  Future<Null> _dismiss(_RefreshIndicatorMode newMode) async {
    // This can only be called from _show() when refreshing and
    // _handleScrollNotification in response to a ScrollEndNotification or
    // direction change.
    assert(newMode == _RefreshIndicatorMode.canceled ||
        newMode == _RefreshIndicatorMode.done);

    setState(() {
      _mode = newMode;
    });

    switch (_mode) {
      case _RefreshIndicatorMode.done:
        await _scaleController.animateTo(1.0,
            duration: _kIndicatorScaleDuration);
        break;
      case _RefreshIndicatorMode.canceled:
        await _positionController.animateTo(0.0,
            duration: _kIndicatorScaleDuration);
        break;
      default:
        assert(false);
    }

    if (mounted && _mode == newMode) {
      _dragOffset = null;
      _isIndicatorAtTop = null;

      setState(() => _mode = null);
    }
  }

  void _show() {
    assert(_mode != _RefreshIndicatorMode.refresh);
    assert(_mode != _RefreshIndicatorMode.snap);

    _mode = _RefreshIndicatorMode.snap;
    _positionController
        .animateTo(1.0 / _kDragSizeFactorLimit,
            duration: _kIndicatorSnapDuration)
        .then((value) {
      if (mounted && _mode == _RefreshIndicatorMode.snap) {
        assert(widget.onRefresh != null);
        setState(() => _mode = _RefreshIndicatorMode.refresh);
        print("ReactiveRefreshIndicator: called onRefresh");
        widget.onRefresh();
      }
    });
  }

  final GlobalKey _key = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    final Widget child = new NotificationListener<ScrollNotification>(
      key: _key,
      onNotification: _handleScrollNotification,
      child: new NotificationListener<OverscrollIndicatorNotification>(
        onNotification: _handleGlowNotification,
        child: widget.child,
      ),
    );

    if (_mode == null) {
      assert(_dragOffset == null);
      assert(_isIndicatorAtTop == null);

      return child;
    }

    assert(_dragOffset != null);
    assert(_isIndicatorAtTop != null);

    final bool showIndeterminateIndicator =
        _mode == _RefreshIndicatorMode.refresh ||
            _mode == _RefreshIndicatorMode.done;

    return new Stack(
      children: <Widget>[
        child,
        new Positioned(
          top: _isIndicatorAtTop ? 0.0 : null,
          bottom: !_isIndicatorAtTop ? 0.0 : null,
          left: 0.0,
          right: 0.0,
          child: new SizeTransition(
            axisAlignment: _isIndicatorAtTop ? 1.0 : -1.0,
            sizeFactor: _positionFactor, // this is what brings it down
            child: new Container(
              padding: _isIndicatorAtTop
                  ? new EdgeInsets.only(top: widget.displacement)
                  : new EdgeInsets.only(bottom: widget.displacement),
              alignment: _isIndicatorAtTop
                  ? Alignment.topCenter
                  : Alignment.bottomCenter,
              child: new ScaleTransition(
                scale: _scaleFactor,
                child: new AnimatedBuilder(
                  animation: _positionController,
                  builder: (BuildContext context, Widget child) {
                    return new RefreshProgressIndicator(
                      value: showIndeterminateIndicator ? null : _value.value,
                      valueColor: _valueColor,
                      backgroundColor: widget.backgroundColor,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
