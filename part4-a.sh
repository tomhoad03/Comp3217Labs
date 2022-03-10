export TPM2TOOLS_TCTI=mssim:host=localhost,port=2321
tpm2_clear
tpm2_startup -c

tpm2_flushcontext -t

tpm2_createprimary -c primaryA.ctx

# create an aes128 symmetric key
tpm2_create -G aes128 -u keyA.pub -r keyA.priv -C primaryA.ctx
