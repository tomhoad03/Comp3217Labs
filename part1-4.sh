export TPM2TOOLS_TCTI=mssim:host=localhost,port=2321
tpm2_clear
tpm2_startup -c

tpm2_flushcontext -t

# create a symmetric key using aes128
tpm2_createprimary -c aes.ctx
tpm2_create -G aes128 -u aes.pub -r aes.priv -C aes.ctx
