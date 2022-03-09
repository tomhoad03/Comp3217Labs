export TPM2TOOLS_TCTI=mssim:host=localhost,port=2321
tpm2_clear
tpm2_startup -c
tpm2_changeauth -c owner password

tpm2_createprimary -C e -c primary.ctx
tpm2_create -G aes128 -u aes.pub -r aes.priv -C primary.ctx

tpm2_flushcontext -t

tpm2_load -C primary.ctx -u aes.pub -r aes.priv -c aes.ctx

tpm2_encryptdecrypt -c aes.ctx -o dummy_enc1.txt dummy.txt

tpm2_flushcontext -t

tpm2_pcrread -o pcr.dat "sha1:0,1,2,3"
tpm2_startauthsession -S session.ctx
tpm2_policypcr -S session.ctx -l "sha1:0,1,2,3" -f pcr.dat -L policy1.dat

tpm2_flushcontext session.ctx

tpm2_create -Q -u key.pub -r key.priv -C primary.ctx -L policy1.dat -i- <<< dummy_enc1.txt

tpm2_flushcontext -t

tpm2_load -C primary.ctx -u key.pub -r key.priv -n unseal.key.name -c unseal.key.ctx

tpm2_startauthsession --policy-session -S session.dat
tpm2_policypcr -S session.dat -l "sha1:0,1,2,3" -f pcr.dat -L policy.dat
tpm2_unseal -p session:session.dat -c unseal.key.ctx -o dummy_enc2.txt

tpm2_flushcontext -t

tpm2_load -C primary.ctx -u aes.pub -r aes.priv -c aes.ctx
tpm2_encryptdecrypt -d -c aes.ctx -o dummy_enc2.txt dummy2.txt
cat dummy2.txt

tpm2_flushcontext session.dat
