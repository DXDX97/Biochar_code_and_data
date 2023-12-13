clear
z_bcs_har=random(makedist('TRIANGULAR','A',30,'B',36,'C',90),1,10000);
biocharef=normrnd(0.29,0.0353,1,10000);
ccontent=normrnd(0.66,0.0803,1,10000);
bc_yield=random(makedist('TRIANGULAR','A',0.11,'B',0.18,'C',0.53),1,10000);
cprice=normrnd(331.6,40.3197,1,10000);
yield=normrnd(6.1,2.9668,1,10000);
k=normrnd(25,15.1989,1,10000);
u=normrnd(0.2,0.0301,1,10000);
v=normrnd(13.4,1.6293,1,10000);

z_bcs_biotrans=k.*u;
z_bcs_bctrans=k.*u.*biocharef;
z_bcs_appli=v.*biocharef;
z_bcs_inv=random(makedist('TRIANGULAR','A',4.1,'B',4.8,'C',6.9),1,10000);
z_bcs_om=random(makedist('TRIANGULAR','A',17.9,'B',22.5,'C',27.2),1,10000);


tenergye=normrnd(0.71,0.1079,1,10000);
biolhv=normrnd(15,1.8239,1,10000);
lhv=normrnd(23,4.1949,1,10000);
p_gas=normrnd(10.6,1.2889,1,10000);
b_bcs_gas=p_gas.*((90*0.0036+biolhv).*tenergye-lhv.*biocharef);

t_bc=biocharef;
e_bcs_cap=biocharef.*ccontent*44/12;
b_bcs_yield_base=cprice.*yield.*bc_yield;
b_bcs_yield=b_bcs_yield_base/20.*t_bc;


decomp=normrnd(0.25,0.0912,1,10000);
z_biochar=z_bcs_har + z_bcs_biotrans + 10 + z_bcs_bctrans + z_bcs_appli + z_bcs_inv + z_bcs_om - b_bcs_gas - b_bcs_yield;
e_biochar=e_bcs_cap.*(1-decomp);
unitcost=z_biochar./e_biochar;

biomass_rice=random(makedist('TRIANGULAR','A',-0.09,'B',-0.0077,'C',0.056),1,10000);
biomass_wheat=random(makedist('TRIANGULAR','A',-0.2,'B',-0.04,'C',0.13),1,10000);
biomass_maize=random(makedist('TRIANGULAR','A',-0.29,'B',0.0028,'C',0.41),1,10000);
biomass_for=random(makedist('TRIANGULAR','A',0.11,'B',0.91,'C',1.92),1,10000);
biomass_er=random(makedist('TRIANGULAR','A',-0.043,'B',-0.0063,'C',0.415),1,10000);
biomass_grass=43;
biomass=(1+biomass_rice)*0.202+(1+biomass_wheat)*0.123+(1+biomass_maize)*0.309+(1+biomass_for)*0.232+(1+biomass_er)*0.66+biomass_grass*0.001+0.16;
tcr=e_biochar.*biomass;
x1=0:0.0001:0.9999;
x2=-150:0.05:349.95;
fx1=normpdf(x1,mean(e_biochar),std(e_biochar));
fx2=normpdf(x2,mean(unitcost),std(unitcost));
m_e_biochar=mean(e_biochar);
std_e_biochar=std(e_biochar);
m_e_biomass=mean(biomass);
std_e_biomass=std(biomass);
m_unitcost=mean(unitcost);
std_unitcost=std(unitcost);
m_tcr=mean(tcr);
std_tcr=std(tcr);
plot(x1,fx1,'g-');
plot(x2,fx2,'g-');




