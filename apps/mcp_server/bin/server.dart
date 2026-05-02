/// Entry point for the Self-Management MCP server.
///
/// Connects via stdio transport for use with MCP-capable IDE integrations.
///
/// Configuration:
///   - `API_BASE_URL` env var: Backend URL (default: http://localhost:8080)
library;

import 'dart:convert';
import 'dart:io' as io;

import 'package:async/async.dart';
import 'package:stream_channel/stream_channel.dart';

import 'package:self_management_mcp_server/server.dart';

void main() {
  final baseUrl =
      io.Platform.environment['API_BASE_URL'] ?? 'http://localhost:8080';

  final channel = StreamChannel.withCloseGuarantee(io.stdin, io.stdout)
      .transform(StreamChannelTransformer.fromCodec(utf8))
      .transformStream(const LineSplitter())
      .transformSink(
        StreamSinkTransformer.fromHandlers(
          handleData: (data, sink) {
            sink.add('$data\n');
          },
        ),
      );

  SelfManagementMCPServer(
    channel,
    baseUrl: baseUrl,
  );
}
