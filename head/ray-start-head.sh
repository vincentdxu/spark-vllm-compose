#!/bin/sh

ray start --head --port 6379 --object-store-memory $RAY_object_store_memory --num-cpus 2 \
         --node-ip-address $VLLM_HOST_IP --include-dashboard=false --disable-usage-stats

first=0
while true; do
  nodes=$(($(ray status 2>&1 | awk '/Active:/,/Pending:/' | grep -c "^ *[0-9]* node_")))

  [ "$nodes" -ge 2 ] && break
  [ "$seen" = "yes" -a "$nodes" -eq 0 ] && echo "Ray exited" && exit 1

  [ "$nodes" -gt 0 ] && seen=yes


  echo "⏳ Waiting... Found $nodes/2 nodes"
  sleep 5
done


echo "✓ Ray cluster ready with $nodes nodes"
