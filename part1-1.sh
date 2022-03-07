export TPM2TOOLS_TCTI=mssim:host=localhost,port=2321
tpm2_startup -c

tpm2_flushcontext -t

# read existing pcr10, then write hash of dummy.txt to it
tpm2_pcrread sha256:10
tpm2_pcrextend 10:sha256=$(tpm2_hash --hex -C e -g sha256 dummy.txt)
tpm2_pcrread sha256:10

tpm2_clear
