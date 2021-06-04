[[ -d /var/lib/netdata/cloud.d ]] && rm -rf /var/lib/netdata/cloud.d/


 netdata-claim.sh -token=wUYlA0noxiArzbldmc3TIfFtOC27TezEFKlOSgDvnyCd5WW-nV1XfqGTMcApbQsN7kRY_AgjktTzwhF1sj8sX0UQbAEj7uEaFcmM4NhuTkuHUiA93Btnqx8kmwdXql8MD4KQ4bI -rooms=05cb9409-1b2a-41fb-be00-f8c1c173d01e -url=https://app.netdata.cloud -id=$(uuidgen)
