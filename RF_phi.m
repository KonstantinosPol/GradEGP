function phi_xt_s=RF_phi(x,V,D)
Vtx=V*x;
phi_xt_s=(1/sqrt(D))*[cos(Vtx); sin(Vtx)];

end