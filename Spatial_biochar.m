clear

coef=xlsread('D:\Biochar\agri_coef.xlsx','NEW RESULTS','I42:O49');
coef2=xlsread('D:\Biochar\agri_coef.xlsx','NEW RESULTS','E42:F49');
coef3=xlsread('D:\Biochar\agri_coef.xlsx','NEW RESULTS','AC42:AF49');


z_bcs_har=coef(:,1);
biocharef=coef2(:,1);
ccontent=coef2(:,2);
bc_yield=coef3(:,4);
cprice=coef3(:,1);
gas=coef3(:,2);
BT=coef3(:,3);

coef4=xlsread('D:\Biochar\Biomass_SUS.xlsx','Biomass_SUS_ML','D2:AJ3392');
coef4(isnan(coef4))=0;

yield(:,1)=coef4(:,3)./coef4(:,2);
yield(:,2)=coef4(:,6)./coef4(:,5);
yield(:,3)=coef4(:,9)./coef4(:,8);
yield(:,4)=coef4(:,12)./coef4(:,11);
yield(:,5)=1.18*ones(3391,1);
yield(:,6)=5*ones(3391,1);
yield(:,7)=coef4(:,23);
yield(:,8)=coef4(:,24);
yield(isnan(yield))=0;

Biosus(:,1)=coef4(:,1)*0.803562;
Biosus(:,2)=coef4(:,4)*0.803562;
Biosus(:,3)=coef4(:,7)*0.803562;
Biosus(:,4)=coef4(:,10)*0.803562;
Biosus(:,5)=coef4(:,19);
Biosus(:,6)=coef4(:,17);
Biosus(:,7)=coef4(:,20);
Biosus(:,8)=coef4(:,21);
Biosum=sum(Biosus,1);

yielddis=coef4(:,32);
aboundance=coef4(:,33);
er=6.6174;

z_bcs_biotrans=21.25*1.5*ones(8,1);
z_bcs_bctrans=21.25*1.5*biocharef.*ones(8,1);
z_bcs_appli=13.4*er*biocharef.*ones(8,1);
z_bio_stor=10*er*ones(8,1);
z_bcs_inv=4.8*er*ones(8,1);
z_bcs_om=22.5*er*ones(8,1);
P_bcs_gas=76.27*0.92;
b_bcs_gas=gas*P_bcs_gas;
t_bc=biocharef;
e_bcs_cap=biocharef.*ccontent*44/12*0.7508;

for i=1:8
    for j=1:length(yield)
    b_bcs_yield_base(j,i)=cprice(i)*yield(j,i)*bc_yield(i);

    b_bcs_yield(j,i)=b_bcs_yield_base(j,i)/BT(i)*t_bc(i)*(1+yielddis(j));


    z_biochar(j,i)=z_bcs_har(i) + z_bcs_biotrans(i) + z_bio_stor(i) + z_bcs_bctrans(i) + z_bcs_appli(i) + z_bcs_inv(i)*aboundance(j) + z_bcs_om(i) - b_bcs_gas(i) - b_bcs_yield(j,i);
    e_biochar(i)=e_bcs_cap(i);

    unitcost(j,i)=z_biochar(j,i)/e_biochar(i);
    end
end
CDR=Biosus.*e_bcs_cap';

UC=sum(unitcost.*CDR,2)./sum(CDR,2);
m=unitcost.*CDR;
UC_usdollar=UC/er;
UC_agri=sum(m(:,1:4),2)./sum(CDR(:,1:4),2)/er;
UC_FOR=unitcost(:,6)/er;
UC_FOR(isnan(UC_FOR))=0;
UC_agri(isnan(UC_agri))=0;
CDRT=sum(CDR,2);
fig_cost_CDRT=[CDRT  UC_usdollar UC_agri UC_FOR ];

xlswrite('D:\Biochar\Biomass_SUS.xlsx',fig_cost_CDRT,'fig_cost_CDRT','A2:D3392');


[~,txt]=xlsread('D:\Biochar\Biomass_SUS.xlsx','Province_code','B1:B31');
[~,txt2]=xlsread('D:\Biochar\Biomass_SUS.xlsx','Biomass_SUS_ML','AK2:AK3392');
region=xlsread('D:\Biochar\Biomass_SUS.xlsx','Province_code','A1:A31');
province=(1:31)';
NUMregion=zeros(3391,1);
NUMprovince=zeros(3391,1);

for i=1:31   
    for j =1:3391
        if isequal(txt(i),txt2(j))==1 
            NUMregion(j,:)=region(i);
            NUMprovince(j,:)=province(i);
        end
    end
end
region_show=[NUMregion CDR/1000000  CDRT/1000000  UC/6.6174  CDRT/1000000.*UC/6.6174  Biosus/1000000];
province_show=[NUMprovince CDR/1000000  CDRT/1000000  UC/6.6174  CDRT/1000000.*UC/6.6174  Biosus/1000000];
for i=1:6
    region_table(i,:)=[i  sum(region_show(region_show(:,1)==i,2:9))  sum(region_show(region_show(:,1)==i,10))  sum(region_show(region_show(:,1)==i,12))/sum(region_show(region_show(:,1)==i,10))  sum(region_show(region_show(:,1)==i,13:20))];
end

for i=1:31
    province_table(i,:)=[i  sum(province_show(province_show(:,1)==i,2:9))  sum(province_show(province_show(:,1)==i,10))  sum(province_show(province_show(:,1)==i,12))/sum(province_show(province_show(:,1)==i,10))  sum(province_show(province_show(:,1)==i,13:20))];
end

xlswrite('D:\Biochar\Biomass_SUS.xlsx',region_table,'region_table','B2:T7');
xlswrite('D:\Biochar\Biomass_SUS.xlsx',province_table,'province_table','B2:T32');

pre_fig=[NUMregion CDRT/1000000  UC/6.6174];
Tregion=sortrows(pre_fig,3);

NorthChina=pre_fig(pre_fig(:,1)==1,:);
NorthChina2=sortrows(NorthChina,3);

NortheastChina=pre_fig(pre_fig(:,1)==2,:);
NortheastChina2=sortrows(NortheastChina,3);

EastChina=pre_fig(pre_fig(:,1)==3,:);
EastChina2=sortrows(EastChina,3);

CentralandSouthChina=pre_fig(pre_fig(:,1)==4,:);
CentralandSouthChina2=sortrows(CentralandSouthChina,3);

SouthwestChina=pre_fig(pre_fig(:,1)==5,:);
SouthwestChina2=sortrows(SouthwestChina,3);

NorthwestChina=pre_fig(pre_fig(:,1)==6,:);
NorthwestChina2=sortrows(NorthwestChina,3);

xlswrite('D:\Biochar\Biomass_SUS.xlsx',NorthChina2,'fig','A2:C3392');
xlswrite('D:\Biochar\Biomass_SUS.xlsx',NortheastChina2,'fig','E2:G3392');
xlswrite('D:\Biochar\Biomass_SUS.xlsx',EastChina2,'fig','I2:K3392');
xlswrite('D:\Biochar\Biomass_SUS.xlsx',CentralandSouthChina2,'fig','M2:O3392');
xlswrite('D:\Biochar\Biomass_SUS.xlsx',SouthwestChina2,'fig','Q2:S3392');
xlswrite('D:\Biochar\Biomass_SUS.xlsx',NorthwestChina2,'fig','U2:W3392');
xlswrite('D:\Biochar\Biomass_SUS.xlsx',Tregion,'fig','Y2:AA3392');