[[ -d /var/lib/netdata/cloud.d ]] && rm -rf /var/lib/netdata/cloud.d/


netdata-claim.sh -token=wUYlA0noxiArzbldmc3TIfFtOC27TezEFKlOSgDvnyCd5WW-nV1XfqGTMcApbQsN7kRY_AgjktTzwhF1sj8sX0UQbAEj7uEaFcmM4NhuTkuHUiA93Btnqx8kmwdXql8MD4KQ4bI -rooms=cf3b42e6-1c78-4f24-856d-8bd462310306 -url=https://app.netdata.cloud  -id=$(uuidgen)

