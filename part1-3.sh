export TPM2TOOLS_TCTI=mssim:host=localhost,port=2321
tpm2_clear
tpm2_startup -c

tpm2_flushcontext -t

tpm2_createprimary -C e -c srk.ctx -p 9854
tpm2_create -G rsa -u srk.pub -r srk.priv -C srk.ctx -P 9854

# this will allow you to load the key
#tpm2_load -C srk.ctx -u srk.pub -r srk.priv -c rsasrk.ctx -P 9854

# this brute force attack will not work, TPM uses a DA lockout to prevent more than a few loads
for i in {0..9999}
do
	tpm2_flushcontext -t
	echo $i
	tpm2_load -C srk.ctx -u srk.pub -r srk.priv -c rsasrk.ctx -P $i
done
