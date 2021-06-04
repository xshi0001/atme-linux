[[ -d /var/lib/netdata/cloud.d ]] && rm -rf /var/lib/netdata/cloud.d/


 netdata-claim.sh -token=Pkc8lAkQXLEnDbAxl-FupYTgQUNw-77Y-laSoHC-I-3kyk-6-_6f9F2HKwl-1VSSsWO2oDfqmk8RXiqjgVkks_rrY35I8Gj2QlnAYp0Sny0rnD17zp4AGJQKFkLD4BDjuovLUeg -rooms=4928390e-716e-4736-bb97-ed0ee3d5c34d -url=https://app.netdata.cloud -id=$(uuidgen)
