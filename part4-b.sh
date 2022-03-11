export TPM2TOOLS_TCTI2=mssim:host=localhost,port=2323
tpm2_clear
tpm2_startup -c

tpm2_flushcontext -t
