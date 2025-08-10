#!/bin/bash

set +m

echo "🚀 Starting Kevin's Store services..."

# Start Temporal Server
echo -n "Starting Temporal server..."
temporal server start-dev > temporal-server.log 2>&1 &
TEMPORAL_PID=$!

# Wait for Temporal to be ready
for i in {1..20}; do
  if temporal workflow list > /dev/null 2>&1; then
    echo " ✅ ready"
    break
  fi
  sleep 2
done

# Start Rails Worker
echo -n "Starting Rails Temporal worker..."
bundle exec rails temporal:worker > temporal-worker.log 2>&1 &
WORKER_PID=$!
sleep 5

if kill -0 $WORKER_PID 2>/dev/null; then
  echo " ✅ ready"
else
  echo " ❌ failed to start"
fi

# Start Rails Server
echo -n "Starting Rails server..."
bundle exec rails server -p 3001 > rails-server.log 2>&1 &
SERVER_PID=$!

# Wait for Rails to be ready
for i in {1..10}; do
  if curl -s http://localhost:3001 > /dev/null 2>&1; then
    echo " ✅ ready"
    break
  fi
  sleep 2
done

echo
echo "Services"
echo "├── Temporal Server: http://localhost:8233 (PID: $TEMPORAL_PID)"
echo "├── Rails Worker: Running (PID: $WORKER_PID)" 
echo "└── 🌐 Rails: http://localhost:3001 (PID: $SERVER_PID)"
echo
echo "📋 Log files: temporal-server.log, temporal-worker.log, rails-server.log"

set -m