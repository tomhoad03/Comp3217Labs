tpm2_flushcontext -t

tpm2_startup -c -T mssim:host=localhost,port=2321
export TPM2TOOLS_TCTI=mssim:host=localhost,port=2321

tpm2_createprimary -C e -c srk.ctx
tpm2_create -G rsa -u srk.pub -r srk.priv -C srk.ctx -p 9854

tpm2_flushcontext -t

tpm2_load -C srk.ctx -u srk.pub -r srk.priv -c rsasrk.ctx

for i in {0..9999}
do
	tpm2_flushcontext -t
	echo $i
	tpm2_sign -c rsasrk.ctx -g sha256 -o sigsrk.rssa message.dat -p $i
	tpm2_verifysignature -c rsasrk.ctx -g sha256 -s sigsrk.rssa -m message.dat
done

