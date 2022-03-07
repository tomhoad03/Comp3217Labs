export TPM2TOOLS_TCTI=mssim:host=localhost,port=2321
tpm2_clear
tpm2_startup -c
tpm2_changeauth -c owner password

tpm2_createprimary -c primary.ctx -P password
tpm2_create -G aes128 -u aes.pub -r aes.priv -C primary.ctx

tpm2_flushcontext -t

tpm2_load -C primary.ctx -u aes.pub -r aes.priv -c aes.ctx

tpm2_encryptdecrypt -c aes.ctx -o dummy2.txt dummy2.txt
cat dummy2.txt

tpm2_flushcontext -t

tpm2_encryptdecrypt -d -c aes.ctx -o dummy2.txt dummy2.txt
cat dummy2.txt
