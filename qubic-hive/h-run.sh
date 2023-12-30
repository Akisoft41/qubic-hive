
[[ ! -e ./appsettings.json ]] && echo "No config file found, exiting" && exit 1

echo $MINER_LOG_BASENAME.log

./qli-Client | tee --append $MINER_LOG_BASENAME.log

