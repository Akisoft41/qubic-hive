
get_miner_uptime(){
  local a=0
  let a=`stat --format='%Y' $log_name`-`stat --format='%Y' $conf_name`
  echo $a
}

get_log_time_diff(){
  local a=0
  let a=`date +%s`-`stat --format='%Y' $log_name`
  echo $a
}




#######################
# MAIN script body
#######################


#log_name="$MINER_LOG_BASENAME.log"
#conf_name="$CUSTOM_CONFIG_FILENAME"
#custom_version="$CUSTOM_VERSION"

log_basename="/var/log/miner/custom/custom"
log_name="$log_basename.log"
log_head_name="${log_basename}_head.log"
conf_name="/hive/miners/custom/qubic-hive/appsettings.json"
custom_version=1.8.2


diffTime=$(get_log_time_diff)
maxDelay=250


# If log is fresh the calc miner stats or set to null if not
if [ "$diffTime" -lt "$maxDelay" ]; then

  ver="$custom_version"
  hs_units="khs"
  algo="qubic"
  
  uptime=$(get_miner_uptime)
  [[ $uptime -lt 60 ]] && head -n 50 $log_name > $log_head_name
  
  cpu_count=`cat $log_head_name | tail -n 50 | grep "threads are used" | tail -n 1 | cut -d " " -f3`
  [[ $cpu_count = "" ]] && cpu_count=0
  gpu_count=`cat $log_head_name | tail -n 50 | grep "CUDA devices are used" | tail -n 1 | cut -d " " -f3`
  [[ $gpu_count = "" ]] && gpu_count=0
  
  if [ $cpu_count -eq 0 ] && [ $gpu_count -eq 0 ]; then
    echo ...
    cat $log_name | grep -E "threads are used|CUDA devices are used" | tail -n 1 > $log_head_name
    cpu_count=`cat $log_head_name | tail -n 50 | grep "threads are used" | tail -n 1 | cut -d " " -f3`
    [[ $cpu_count = "" ]] && cpu_count=0
    gpu_count=`cat $log_head_name | tail -n 50 | grep "CUDA devices are used" | tail -n 1 | cut -d " " -f3`
    [[ $gpu_count = "" ]] && gpu_count=0
  fi
  
  cpu_temp=`cpu-temp`
  [[ $cpu_temp = "" ]] && cpu_temp=null
  
  khs=`cat $log_name | tail -n 50 | grep "Search" | tail -n 1 | cut -d " " -f11 | awk '{print $1/1000}'`
  ac=`cat $log_name | tail -n 50 | grep "Search" | tail -n 1 | cut -d " " -f6 | cut -d "/" -f1`
  rj=0
  
  echo ----------
  echo cpu_count: $cpu_count
  echo gpu_count: $gpu_count
  echo gpu_stats: $gpu_stats
  echo cpu_indexes_array: $cpu_indexes_array
  #echo gpu_detect_json: $gpu_detect_json
  echo ----------
  
  if [[ $gpu_count -eq 0 ]]; then
    # CPU
    hs[0]=`cat $log_name | tail -n 50 | grep "Search" | tail -n 1 | cut -d " " -f8 | awk '{print $1/1000}'`
    temp[0]=$cpu_temp
    fan[0]=""
    bus_numbers[0]="null"
  else
    # GPUs
    gpu_temp=$(jq '.temp' <<< $gpu_stats)
    gpu_fan=$(jq '.fan' <<< $gpu_stats)
    gpu_bus=$(jq '.busids' <<< $gpu_stats)
  	if [[ $cpu_indexes_array != '[]' ]]; then
      #remove Internal Gpus
  		gpu_temp=$(jq -c "del(.$cpu_indexes_array)" <<< $gpu_temp) &&
  		gpu_fan=$(jq -c "del(.$cpu_indexes_array)" <<< $gpu_fan) &&
  		gpu_bus=$(jq -c "del(.$cpu_indexes_array)" <<< $gpu_bus)
    fi
    for (( i=0; i < ${gpu_count}; i++ )); do
      hs[$i]=`cat $log_name | tail -n 50 | grep "GPU#$i" | grep "iters/sec" | tail -n 1 | cut -d ":" -f6 | cut -d " " -f2 | awk '{print $1/1000}'`
      [[ -z ${hs[$i]} ]] && hs[$i]=0
      temp[$i]=$(jq .[$i] <<< $gpu_temp)
      fan[$i]=$(jq .[$i] <<< $gpu_fan)
      busid=$(jq .[$i] <<< $gpu_bus)
      bus_numbers[$i]=`echo $busid | cut -d ":" -f1 | cut -c2- | awk -F: '{ printf "%d\n",("0x"$1) }'`
    done
  fi

  stats=$(jq -nc \
            --arg khs "$khs" \
            --arg hs_units "$hs_units" \
            --argjson hs "`echo ${hs[@]} | tr " " "\n" | jq -cs '.'`" \
            --argjson temp "`echo ${temp[@]} | tr " " "\n" | jq -cs '.'`" \
            --argjson fan "`echo ${fan[@]} | tr " " "\n" | jq -cs '.'`" \
            --arg uptime "$uptime" \
            --arg ver "$ver" \
            --arg ac "$ac" --arg rj "$rj" \
            --arg algo "$algo" \
            --argjson bus_numbers "`echo ${bus_numbers[@]} | tr " " "\n" | jq -cs '.'`" \
            '{$hs, $hs_units, $temp, $fan, $uptime, $ver, ar: [$ac, $rj], $algo, $bus_numbers}')

else
  stats=""
  khs=0
fi

# debug output

 echo khs:   $khs
 echo stats: $stats
 echo ----------
