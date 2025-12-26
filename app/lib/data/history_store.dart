import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/packaging_request.dart';
import '../utils/prompt_options.dart';
import '../models/packaging_response.dart';

class HistoryEntry {
  HistoryEntry({
    required this.id,
    required this.createdAt,
    required this.request,
    required this.response,
  });

  final String id;
  final DateTime createdAt;
  final PackagingRequest request;
  final PackagingResponse response;

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': createdAt.toIso8601String(),
        'request': request.toJson(),
        'response': response.toJson(),
      };

  static HistoryEntry fromJson(Map<String, dynamic> json) => HistoryEntry(
        id: json['id'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
        request:
            PackagingRequest.fromJson(json['request'] as Map<String, dynamic>),
        response: PackagingResponse.fromJson(
            json['response'] as Map<String, dynamic>),
      );

  static HistoryEntry temporary(PackagingResponse response) {
    const dummyReq = PackagingRequest(
      marketplace: Marketplace.other,
      category: '',
      productName: '',
      brand: null,
      characteristics: [],
      variants: [],
      audience: '',
      tone: Tone.neutral,
      forbiddenWords: [],
      forbiddenClaims: [],
      outputOptions: OutputOptions(),
      language: 'ru',
      installationId: 'temp',
    );
    return HistoryEntry(
      id: 'temp',
      createdAt: DateTime.now(),
      request: dummyReq,
      response: response,
    );
  }

  static HistoryEntry empty() {
    const dummyResp = PackagingResponse(
      meta: Meta(requestId: 'n/a', provider: 'n/a', model: 'n/a', latencyMs: 0),
      missingInfoQuestions: [],
      riskFlags: [],
      outputs: Outputs(
        titles: [],
        bullets: [],
        descriptionShort: '',
        descriptionLong: '',
        seoKeywords: [],
        faq: [],
        reviewReplies: ReviewReplies(positive: [], neutral: [], negative: []),
      ),
      complianceNotes: [],
    );
    return temporary(dummyResp);
  }
}

abstract class HistoryStore {
  Future<List<HistoryEntry>> list({String? query});
  Future<HistoryEntry> save({
    required PackagingRequest request,
    required PackagingResponse response,
  });
  Future<void> delete(String id);
  Future<HistoryEntry?> getById(String id);
}

/// MVP storage using SharedPreferences.
/// TODO(P1): replace with drift (SQLite) for better indexing and larger history.
class SharedPrefsHistoryStore implements HistoryStore {
  static const _key = 'history_v1';
  static const _maxItems = 100;

  @override
  Future<List<HistoryEntry>> list({String? query}) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final list = (jsonDecode(raw) as List<dynamic>)
        .map((e) => HistoryEntry.fromJson(e as Map<String, dynamic>))
        .toList();

    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final q = query?.trim().toLowerCase();
    if (q == null || q.isEmpty) return list;
    return list.where((e) {
      final name = e.request.productName.toLowerCase();
      final cat = e.request.category.toLowerCase();
      return name.contains(q) || cat.contains(q);
    }).toList();
  }

  @override
  Future<HistoryEntry> save({
    required PackagingRequest request,
    required PackagingResponse response,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await list();
    final entry = HistoryEntry(
      id: const Uuid().v4(),
      createdAt: DateTime.now(),
      request: request,
      response: response,
    );
    final next = [entry, ...current].take(_maxItems).toList();
    await prefs.setString(
        _key, jsonEncode(next.map((e) => e.toJson()).toList()));
    return entry;
  }

  @override
  Future<void> delete(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await list();
    final next = current.where((e) => e.id != id).toList();
    await prefs.setString(
        _key, jsonEncode(next.map((e) => e.toJson()).toList()));
  }

  @override
  Future<HistoryEntry?> getById(String id) async {
    final current = await list();
    for (final e in current) {
      if (e.id == id) return e;
    }
    return null;
  }
}

/// Test-friendly implementation.
class InMemoryHistoryStore implements HistoryStore {
  final List<HistoryEntry> _items = [];

  @override
  Future<void> delete(String id) async {
    _items.removeWhere((e) => e.id == id);
  }

  @override
  Future<HistoryEntry?> getById(String id) async {
    try {
      return _items.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<HistoryEntry>> list({String? query}) async {
    final q = query?.trim().toLowerCase();
    final items = List<HistoryEntry>.from(_items);
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (q == null || q.isEmpty) return items;
    return items.where((e) {
      return e.request.productName.toLowerCase().contains(q) ||
          e.request.category.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Future<HistoryEntry> save({
    required PackagingRequest request,
    required PackagingResponse response,
  }) async {
    final entry = HistoryEntry(
      id: const Uuid().v4(),
      createdAt: DateTime.now(),
      request: request,
      response: response,
    );
    _items.insert(0, entry);
    return entry;
  }
}
