clear

coef=xlsread('D:\Biochar\agri_coef.xlsx','coef','H2:T24');
z_bcs_har=coef(:,3);
biocharef=coef(:,1);
ccontent=coef(:,7);
avoi_CH4=coef(:,5);
avoi_CO2=coef(:,4);
avoi_N2O=coef(:,6);
bc_yield=coef(:,2);
cprice=coef(:,8);
yield=coef(:,9);
biooil=zeros(23,1);
gas=coef(:,11);
BT=coef(:,12);
per=coef(:,13);
er=6.6174;

z_bcs_biotrans=21.25*1.5*ones(23,1);
z_bcs_bctrans=21.25*1.5*biocharef.*ones(23,1);
z_bcs_appli=13.4*er*biocharef.*ones(23,1);
z_bio_stor=10*er*ones(23,1);
z_bcs_inv=4.8*er*ones(23,1);
z_bcs_om=22.5*er*ones(23,1);
P_bcs_gas=76.27*0.92;
b_bcs_gas=gas*P_bcs_gas;
t_bc=biocharef;
e_bcs_cap=biocharef.*ccontent*44/12.*per;

b_bcs_yield_base=cprice.*yield.*bc_yield;
e_bcs_N2O_base=-2.5/1000*avoi_N2O*265;
e_bcs_CH4_base=-215.5/1000*avoi_CH4*28;
e_bcs_CO2_base=-347.3/1000*avoi_CO2;

b_bcs_yield=b_bcs_yield_base./BT.*t_bc;
realinc=bc_yield./BT.*t_bc;
e_bcs_N2O=-2.5/1000*avoi_N2O*265./BT.*t_bc;
e_bcs_CH4=-215.5/1000*avoi_CH4*28./BT.*t_bc;
e_bcs_CO2=-347.3/1000*avoi_CO2./BT.*t_bc;

z_biochar=z_bcs_har + z_bcs_biotrans + z_bio_stor + z_bcs_bctrans + z_bcs_appli + z_bcs_inv + z_bcs_om - b_bcs_gas - b_bcs_yield;
e_biochar=e_bcs_cap;

unitcost=z_biochar./e_biochar;
display=[unitcost e_biochar z_biochar z_bcs_har  z_bcs_biotrans  z_bio_stor z_bcs_bctrans  z_bcs_appli z_bcs_inv  z_bcs_om  -b_bcs_gas  -b_bcs_yield realinc];
display2=[e_bcs_N2O  e_bcs_CH4 e_bcs_CO2];
