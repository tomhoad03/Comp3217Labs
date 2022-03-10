export TPM2TOOLS_TCTI=mssim:host=localhost,port=2321
tpm2_clear
tpm2_startup -c

tpm2_flushcontext -t

tpm2_createprimary -c primary.ctx

# A - create an aes128 symmetric key
tpm2_create -G aes128 -u keyA.pub -r keyA.priv -C primary.ctx

tpm2_flushcontext -t

# A - share the public portion and the context
# B - load the public portion and the context
tpm2_loadexternal -c primary.ctx -u keyA.pub

# B - create an rsa asymmetric key
tpm2_create -G rsa -u keyB.pub -r keyB.priv -C primary.ctx

tpm2_flushcontext -t

# B - share the public portion and the context
# A - load the public portion and the context
tpm2_loadexternal -c primary.ctx -u keyB.pub
