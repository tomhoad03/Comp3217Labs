export TPM2TOOLS_TCTI=mssim:host=localhost,port=2321
tpm2_clear
tpm2_startup -c
tpm2_changeauth -c owner "password"

tpm2_flushcontext -t

# create symmetric key
tpm2_createprimary -C o -c primary.ctx -P "password"
tpm2_create -G aes128 -u aes.pub -r aes.priv -C primary.ctx

tpm2_flushcontext -t

tpm2_load -C primary.ctx -u aes.pub -r aes.priv -c aes.ctx

tpm2_flushcontext -t

# encrypt the secret file - delete original
tpm2_encryptdecrypt -c aes.ctx -o dummy_enc.txt dummy.txt
# rm dummy.txt

tpm2_flushcontext -t

# create a policy for sealing the key
tpm2_startauthsession -S session.ctx
tpm2_policypcr -S session.ctx -l sha1:23 -L policy1
tpm2_flushcontext session.ctx
rm session.ctx

# create a second policy for sealing
tpm2_pcrextend 23:sha1=$(tpm2_hash --hex -C e -g sha1 <<< "password")
tpm2_startauthsession -S session.ctx
tpm2_policypcr -S session.ctx -l sha1:23 -L policy2
tpm2_flushcontext session.ctx
rm session.ctx

# create a policy OR from policy 1 and 2
tpm2_startauthsession -S session.ctx
tpm2_policyor -S session.ctx -L policy3 -l sha256:policy1,policy2
tpm2_flushcontext session.ctx
rm session.ctx

# create a symmetric key for encryption and decryption
tpm2_createprimary -C o -c primary.ctx -P password
tpm2_create -g sha256 -u seal.pub -r seal.priv -C primary.ctx -L policy3 -i- <<< "password"
tpm2_flushcontext -t
tpm2_load -C primary.ctx -u seal.pub -r seal.priv -c seal.ctx

# satisfy the a policy
tpm2_startauthsession -S session.ctx --policy-session
tpm2_policypcr -S session.ctx -l sha1:23
tpm2_policyor -S session.ctx -L policy3 -l sha256:policy1,policy2

tpm2_flushcontext -t
rm primary.ctx

# create symmetric key
tpm2_createprimary -C o -c primary.ctx -P $(tpm2_unseal -p session:session.ctx -c seal.ctx)

tpm2_flushcontext session.ctx
rm session.ctx

tpm2_flushcontext -t

tpm2_load -C primary.ctx -u aes.pub -r aes.priv -c aes.ctx

tpm2_flushcontext -t

# decrypt the secret file
tpm2_encryptdecrypt -d -c aes.ctx -o dummy_dec.txt dummy_enc.txt
cat dummy_dec.txt
