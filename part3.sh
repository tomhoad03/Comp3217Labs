export TPM2TOOLS_TCTI=mssim:host=localhost,port=2321
tpm2_clear
tpm2_startup -c

tpm2_createprimary -C e -c primary.ctx
tpm2_create -C primary.ctx -u key.pub -r key.priv

tpm2_flushcontext -t

tpm2_load -C primary.ctx -u key.pub -r key.priv -c key.ctx
tpm2_quote -Q -c key.ctx -l 0x0004:16,17,18+0x000b:16,17,18
