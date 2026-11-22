import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/sync_service.dart';

enum BackendStatus { initial, checking, online, offline }

class BackendConnectivityNotifier extends StateNotifier<BackendStatus> {
  final SyncService _syncService;
  Timer? _pollingTimer;

  BackendConnectivityNotifier(this._syncService)
    : super(BackendStatus.initial) {
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    state = BackendStatus.checking;
    final isOnline = await _syncService.checkHealth();

    if (isOnline) {
      setOnline();
    } else {
      setOffline();
    }
  }

  void setOnline() {
    if (state != BackendStatus.online) {
      state = BackendStatus.online;
      _startPolling(const Duration(minutes: 5));
    }
  }

  void setOffline() {
    if (state != BackendStatus.offline) {
      state = BackendStatus.offline;
      _startPolling(const Duration(seconds: 10));
    }
  }

  void _startPolling(Duration interval) {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(interval, (_) async {
      final isOnline = await _syncService.checkHealth();
      if (isOnline) {
        setOnline();
      } else {
        setOffline();
      }
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }
}

final backendConnectivityProvider =
    StateNotifierProvider<BackendConnectivityNotifier, BackendStatus>((ref) {
      return BackendConnectivityNotifier(ref.watch(syncServiceProvider));
    });
