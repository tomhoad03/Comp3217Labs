export TPM2TOOLS_TCTI=mssim:host=localhost,port=2321
tpm2_clear
tpm2_startup -c
tpm2_changeauth -c owner password
#tpm2_changeauth -c endorsment password

tpm2_startauthsession -S session1.ctx
tpm2_policypcr -S session1.ctx -l sha1:23 -L set1.pcr0.policy
tpm2_flushcontext session1.ctx
rm session1.ctx

tpm2_pcrextend 23:sha1=f1d2d2f924e986ac86fdf7b36c94bcdf32beec15
tpm2_startauthsession -S session2.ctx
tpm2_policypcr -S session2.ctx -l sha1:23 -L set2.pcr0.policy
tpm2_flushcontext session2.ctx
rm session2.ctx

tpm2_startauthsession -S session3.ctx
tpm2_policyor -S session3.ctx -L policyOR -l sha256:set1.pcr0.policy,set2.pcr0.policy
tpm2_flushcontext session3.ctx
rm session3.ctx

tpm2_createprimary -C o -P password -c prim.ctx
tpm2_create -g sha256 -u sealkey.pub -r sealkey.priv -L policyOR -C prim.ctx -i- <<< "secretpass"
tpm2_flushcontext -t
tpm2_load -C prim.ctx -c sealkey.ctx -u sealkey.pub -r sealkey.priv

tpm2_startauthsession -S session4.ctx --policy-session
tpm2_policypcr -S session4.ctx -l sha1:23
tpm2_policyor -S session4.ctx -L policyOR -l sha245:set1.pcr0.policy,set2.pcr0.policy
unsealed='tpm2_unseal -p session:session4.ctx -c sealkey.ctx'
echo $unsealed
tpm2_flushcontext session4.ctx
rm session4.ctx

tpm2_pcrextend 23:sha1=f1d2d2f924e986ac86fdf7b36c94bcdf32beec15
tpm2_startauthsession -S session5.ctx --policy-session
tpm2_policypcr -S session5.ctx -l sha1:23

tpm2_policyor -S session5.ctx -L policyOR -l sha256:set1.pcr0.policy,set2.pcr0.policy
tpm2_flushcontext session5.ctx
rm session5.ctx

tpm2_pcrreset 23

tpm2_startauthsession -S session6.ctx --policy-session
tpm2_policypcr -S session6.ctx -l sha1:23
tpm2_policyor -S session6.ctx -L policyOR -l sha245:set1.pcr0.policy,set2.pcr0.policy
unsealed='tpm2_unseal -p session:session6.ctx -c sealkey.ctx'
echo $unsealed
tpm2_flushcontext session6.ctx
rm session6.ctx
