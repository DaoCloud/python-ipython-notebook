#!/bin/bash
# Strict mode
set -euo pipefail


# Create the hash to pass to the IPython notebook, but don't export it so it doesn't appear
# as an environment variable within IPython kernels themselves
HASH=$(python -c "from IPython.lib import passwd; print(passwd('${PASSWORD:-admin}'))")

echo "========================================================================"
echo "You can now connect to this Ipython Notebook server using, for example:"
echo ""
echo "  docker run -d -p <your-port>:8888 -e password=<your-password> ipython/notebook"
echo ""
echo "  use password: ${PASSWORD:-admin} to login"
echo ""
echo "========================================================================"

unset PASSWORD

ipython notebook --no-browser --port 8888 --ip=* --NotebookApp.password="$HASH"
