export TPM2TOOLS_TCTI=mssim:host=localhost,port=2321
tpm2_clear
tpm2_startup -c

tpm2_flushcontext -t

tpm2_createprimary -c primary.ctx

# create an aes128 symmetric key
tpm2_create -G aes128 -u keyA.pub -r keyA.priv -C primary.ctx

tpm2_flushcontext -t

# create an rsa asymmetric key
tpm2_create -G rsa -u keyB.pub -r keyB.priv -C primary.ctx

tpm2_flushcontext -t

tpm2_load -C primary.ctx -u keyB.pub -r keyB.priv -c keyB.ctx
tpm2_encryptdecrypt -c keyB.ctx -o keyA_enc.priv keyA.priv
