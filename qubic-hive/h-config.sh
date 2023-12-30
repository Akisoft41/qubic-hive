
# mkfile_from_symlink $CUSTOM_CONFIG_FILENAME


conf=`cat /hive/miners/custom/$CUSTOM_NAME/appsettings_global.json | envsubst`

Settings=$(jq -r .Settings <<< "$conf")


#[[ ! -z $CUSTOM_TEMPLATE ]] &&
#	Settings=`jq --null-input --argjson Settings "$Settings" --arg alias "$CUSTOM_TEMPLATE" '$Settings + {$alias}'`
 
if [[ ! -z $CUSTOM_TEMPLATE ]]; then
  if [[ ${#CUSTOM_TEMPLATE} -lt 60 ]]; then
    # %WORKER_NAME%
	  Settings=`jq --null-input --argjson Settings "$Settings" --arg alias "$CUSTOM_TEMPLATE" '$Settings + {$alias}'`
  elif [[ ${#CUSTOM_TEMPLATE} -eq 60 ]]; then
    # %WAL% with Address Id
	  Settings=`jq --null-input --argjson Settings "$Settings" --arg payoutId "$CUSTOM_TEMPLATE" '$Settings + {$payoutId}'`
  else
    # %WAL%.%WORKER_NAME%
    wallet=${CUSTOM_TEMPLATE%.*}
    len=${#wallet}
    alias=${CUSTOM_TEMPLATE:len}
    alias=${alias#*.}
	  Settings=`jq --null-input --argjson Settings "$Settings" --arg alias "$alias" '$Settings + {$alias}'`
    if [[ ${#wallet} -eq 60 ]]; then
    	Settings=`jq --null-input --argjson Settings "$Settings" --arg payoutId "$wallet" '$Settings + {$payoutId}'`
    else
    	Settings=`jq --null-input --argjson Settings "$Settings" --arg accessToken "$wallet" '$Settings + {$accessToken}'`
    fi
  fi
fi

[[ ! -z $CUSTOM_URL ]] &&
	Settings=`jq --null-input --argjson Settings "$Settings" --arg baseUrl "$CUSTOM_URL" '$Settings + {$baseUrl}'`


#merge user config options into main config
if [[ ! -z $CUSTOM_USER_CONFIG ]]; then
	while read -r line; do
		[[ -z $line ]] && continue
    if [[ ${line:0:7} = "nvtool " ]]; then
      eval $line
    else
		  Settings=$(jq -s '.[0] * .[1]' <<< "$Settings {$line}")
    fi
	done <<< "$CUSTOM_USER_CONFIG"
fi

conf=`jq --null-input --argjson Settings "$Settings" '{$Settings}'`
echo $conf | jq . > $CUSTOM_CONFIG_FILENAME
