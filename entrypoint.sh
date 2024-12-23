#!/bin/bash
set -e

# Print all environment variables for debugging
echo "🔍 Environment Variables:"
env | sort

# Handle workspace mode
if [ "$WORKSPACE_MODE" = "copy" ]; then
    echo "📂 Copying workspace from /host to /workspace"
    cp -R /host/* /workspace/ 2>/dev/null || true
    cp -R /host/.* /workspace/ 2>/dev/null || true
fi

# Execute the command passed to the container
exec "$@"
