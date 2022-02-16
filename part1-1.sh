tpm2_flushcontext -t

tpm2_pcrread sha256:10
tpm2_pcrextend 10:sha256=$(tpm2_hash --hex -C e -g sha256 dummy.txt)
tpm2_pcrread sha256:10
