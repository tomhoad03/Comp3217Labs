export TPM2TOOLS_TCTI=mssim:host=localhost,port=2321
tpm2_clear
tpm2_startup -c
tpm2_changeauth -c owner password

tpm2_flushcontext -t

# create symmetric key
tpm2_createprimary -C o -c primary.ctx -P password
tpm2_create -G aes128 -u aes.pub -r aes.priv -C primary.ctx

tpm2_flushcontext -t

tpm2_load -C primary.ctx -u aes.pub -r aes.priv -c aes.ctx

cat aes.priv

tpm2_flushcontext -t

# encrypt the secret file - delete original
tpm2_encryptdecrypt -c aes.ctx -o dummy_enc.txt dummy.txt
# rm dummy.txt

tpm2_flushcontext -t

# create a policy for sealing the key
tpm2_pcrextend 23:sha1=$(tpm2_hash --hex -C e -g sha1 <<< password)
tpm2_startauthsession -S session.ctx
tpm2_policypcr -S session.ctx -l sha1:23 -L policy
tpm2_flushcontext session.ctx
rm session.ctx

# seal the file away
tpm2_nvdefine -C o -s 144 -L policy -P password 0x01500019 
tpm2_nvwrite -C o -i aes.priv -P password 0x01500019

tpm2_pcrreset 23

tpm2_flushcontext -t

# satisfy the policy
tpm2_pcrextend 23:sha1=$(tpm2_hash --hex -C e -g sha1 <<< password)
tpm2_startauthsession -S session.ctx --policy-session
tpm2_policypcr -S session.ctx -l sha1:23

tpm2_flushcontext -t

# decrypt the secret file
tpm2_nvread 0x01500019 -C o -s 144 -P password -o aes2.priv

tpm2_flushcontext -t

tpm2_load -C primary.ctx -u aes.pub -r aes2.priv -c aes.ctx

tpm2_encryptdecrypt -d -c aes.ctx -o dummy_dec.txt dummy_enc.txt
cat dummy_dec.txt

tpm2_flushcontext session.ctx
rm session.ctx
