function w_vec_out=update_weights(w_vec_in,l_vec,prob_bias)
w_vec_out=w_vec_in.* l_vec;

if (sum(w_vec_out))==0
    w_vec_out=w_vec_in;
else
w_vec_out=w_vec_out/(sum(w_vec_out));
w_vec_out=w_vec_out+prob_bias;
w_vec_out=w_vec_out/(sum(w_vec_out));
end
end