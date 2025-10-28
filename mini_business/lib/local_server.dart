import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'dart:convert';
import 'package:sqlite3/sqlite3.dart';
import 'package:mini_business/services/db_service.dart';

Future<void> startLocalServer() async {
  final app = Router();

  // Path to the app's SQLite file (use DBService helper so we open the
  // exact same database file the app uses).
  String dbPath;
  Database db;
  try {
    dbPath = await DBService.databaseFilePath();
    db = sqlite3.open(dbPath);
  } catch (e) {
    // If we cannot open the DB, respond with a simple error page later.
    dbPath = '';
    db = sqlite3.openInMemory();
    print('Warning: could not open DB file: $e');
  }

  // GET /clients
  app.get('/clients', (Request request) {
    try {
      final results = db.select('SELECT id, name, email, number, pricing FROM clients');
      final data = results
          .map((row) => {
                'id': row['id'],
                'name': row['name'],
                'email': row['email'],
                'number': row['number'],
                'pricing': row['pricing'],
              })
          .toList();
      return Response.ok(jsonEncode(data), headers: {
        'Content-Type': 'application/json',
      });
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': 'DB query failed', 'details': '$e'}), headers: {
        'Content-Type': 'application/json'
      });
    }
  });

  // Serve a simple web page for easy viewing
  app.get('/', (Request request) {
  return Response.ok(r'''
    <!doctype html>
    <html>
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width,initial-scale=1" />
        <title>Clients</title>
        <style>
          body { font-family: system-ui, -apple-system, 'Segoe UI', Roboto, sans-serif; padding: 20px; }
          #controls { margin-bottom: 12px; }
          #status { margin-left: 12px; color: #555; }
          ul { padding-left: 20px; }
        </style>
      </head>
      <body>
        <h2>Client List</h2>
        <div id="controls">
          <button id="updateBtn">Update</button>
          <span id="status">(idle)</span>
        </div>
        <div>
          <strong>Clients:</strong>
          <ul id="clientsList"><li>Loading…</li></ul>
        </div>

        <script>
          async function loadClients() {
            const status = document.getElementById('status');
            const list = document.getElementById('clientsList');
            try {
              status.textContent = 'Loading...';
              const res = await fetch('/clients', { cache: 'no-store' });
              if (!res.ok) throw new Error('HTTP ' + res.status);
              const data = await res.json();
              list.innerHTML = '';
              if (!Array.isArray(data) || data.length === 0) {
                const li = document.createElement('li');
                li.textContent = '(no clients)';
                list.appendChild(li);
              } else {
                data.forEach(c => {
                  const li = document.createElement('li');
                  li.textContent = `${c.id} — ${c.name} ${c.email ? '<' + c.email + '>' : ''} — ${c.number ?? ''} — ${c.pricing ?? ''}`;
                  list.appendChild(li);
                });
              }
              status.textContent = `Loaded ${Array.isArray(data) ? data.length : 0} clients`;
            } catch (err) {
              status.textContent = 'Error loading clients: ' + err;
              list.innerHTML = '<li>(error)</li>';
            }
          }

          window.addEventListener('load', () => {
            loadClients();
            document.getElementById('updateBtn').addEventListener('click', async () => {
              document.getElementById('status').textContent = 'Updating...';
              await loadClients();
            });
          });
        </script>
      </body>
    </html>
    ''', headers: {'Content-Type': 'text/html'});
  });

  final server = await io.serve(app, InternetAddress.anyIPv4, 8080);
  print('✅ Server running on http://${server.address.host}:${server.port}');
}

