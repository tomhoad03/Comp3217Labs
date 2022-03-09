export TPM2TOOLS_TCTI=mssim:host=localhost,port=2321
tpm2_clear
tpm2_startup -c
tpm2_changeauth -c owner password

# create a symmetric key for encryption and decryption
tpm2_createprimary -C e -c primary.ctx
tpm2_create -G aes128 -u aes.pub -r aes.priv -C primary.ctx

tpm2_flushcontext -t

tpm2_load -C primary.ctx -u aes.pub -r aes.priv -c aes.ctx

# encrypt the secret file, remove original if practical
tpm2_encryptdecrypt -c aes.ctx -o dummy_enc.txt dummy.txt
#rm dummy.txt

tpm2_flushcontext -t

# setup a policy
tpm2_pcrread -o pcr.dat sha256:0,1,2,3
tpm2_startauthsession -S session.ctx
tpm2_policypcr -S session.ctx -l sha256:0,1,2,3 -f pcr.dat -L policy1.dat

tpm2_flushcontext session.ctx
rm session.ctx

# create a key from the policy and store the secret file
tpm2_create -u key.pub -r key.priv -C primary.ctx -L policy1.dat -i- <<< aes.ctx
rm aes.ctx

tpm2_flushcontext -t

tpm2_load -C primary.ctx -u key.pub -r key.priv -n unseal.key.name -c unseal.key.ctx

# use the policy key to get the encrypted file back
tpm2_startauthsession --policy-session -S session.ctx
tpm2_policypcr -S session.ctx -l sha256:0,1,2,3 -f pcr.dat -L policy.dat
tpm2_unseal -p session:session.ctx -c unseal.key.ctx -o aes.ctx

tpm2_flushcontext -t

# decrypt the secret file
tpm2_load -C primary.ctx -u aes.pub -r aes.priv -c aes.ctx
tpm2_encryptdecrypt -d -c aes.ctx -o dummy2.txt dummy_enc.txt
cat dummy2.txt
rm dummy_enc.txt

tpm2_flushcontext session.ctx
rm session.ctx
