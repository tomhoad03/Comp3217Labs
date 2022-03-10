export TPM2TOOLS_TCTI2=mssim:host=localhost,port=2323
tpm2_clear
tpm2_startup -c

tpm2_flushcontext -t

tpm2_createprimary -c primaryB.ctx

# create an aes128 symmetric key
tpm2_create -G aes128 -u keyB.pub -r keyB.priv -C primaryB.ctx
