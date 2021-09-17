function ker_params=ker_params_from_vec(ker_vec)

ker_params={};
for s=1:numel(ker_vec)
    ker_params{s}.ker_var=ker_vec(s);
end
