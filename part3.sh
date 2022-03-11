export TPM2TOOLS_TCTI=mssim:host=localhost,port=2321
tpm2_clear
tpm2_startup -c

# create an ek to create an ak to store in memory
tpm2_createek -c 0x81010000 -G rsa -u ek.pub
tpm2_createak -C 0x81010000 -G rsa -c ak.ctx
tpm2_evictcontrol 0x81010001 -c ak.ctx

# create a quote with a nonce
tpm2_quote -c 0x81010001 -l sha256:0,1,2,3,4,5,6,7,8,9 -q 74706d

# after sharing the public portion of the key, load and verify quote
tpm2_loadexternal -G rsa -u ak.pub -c ek.ctx
tpm2_verify signature -c ek.ctx
