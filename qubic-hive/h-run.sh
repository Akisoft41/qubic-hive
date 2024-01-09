# qubic-hive-twice is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or any later version.
# qubic-hive-twice is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with qubic-hive-twice. If not, see <https://www.gnu.org/licenses/>


[[ ! -e ./appsettings.json ]] && echo "No config file found, exiting" && exit 1

./qli-Client | tee --append $MINER_LOG_BASENAME.log

