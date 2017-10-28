function Rpp=avopp(vp1,vs1,d1,vp2,vs2,d2,ang,approx)
%Rpp=AVOPP(vp1,vs1,d1,vp2,vs2,d2,ang,approx);
%
%Calculates P-to-P reflectivity (Rpp) as a function of
%the angle of incidence (ang).
%input parameters:
%  layer 1 (top): vp1, vs1, density1 (d1)
%  layer 2 (bottom): vp2, vs2, density2 (d2)
% ang: vector with angles(DEG)
% approx: 1)Full Zoeppritz(A&R)
%	  2)Aki&Richards
%         3)Shuey's paper
%         4)Castagna's paper->Shuey (slightly different formulation of Shuey)
%
% With no output arguments, plots Rpp vs. angle.
%
% See also AVOPS, AVO_ABE

% written by Ezequiel Gonzalez (Oct,1999)

t=ang.*pi./180;	p=sin(t)./vp1;	ct=cos(t);
da=(d1+d2)/2;     Dd=(d2-d1);
vpa=(vp1+vp2)/2;  Dvp=(vp2-vp1);
vsa=(vs1+vs2)/2;  Dvs=(vs2-vs1);

ip1 = vp1*d1; ip2 = vp2*d2;
is1 = vs1*d1; is2 = vs2*d2;
ipa = (ip1+ip2)/2;  Dip = (ip2-ip1);
isa = (is1+is2)/2;  Dis = (is2-is1);


switch approx
   case 1,		%FULL Zoeppritz (A&K)
	ct2=sqrt(1-(sin(t).^2.*(vp2.^2./vp1.^2)));
	cj1=sqrt(1-(sin(t).^2.*(vs1.^2./vp1.^2)));
	cj2=sqrt(1-(sin(t).^2.*(vs2.^2./vp1.^2)));
	a=(d2.*(1-(2.*vs2.^2.*p.^2)))-(d1.*(1-(2.*vs1.^2.*p.^2)));
	b=(d2.*(1-(2.*vs2.^2.*p.^2)))+(2.*d1.*vs1.^2.*p.^2);
	c=(d1.*(1-(2.*vs1.^2.*p.^2)))+(2.*d2.*vs2.^2.*p.^2);
	d=2.*((d2.*vs2.^2)-(d1.*vs1.^2));
	E=(b.*ct./vp1)+(c.*ct2./vp2);
	F=(b.*cj1./vs1)+(c.*cj2./vs2);
	G=a-(d.*ct.*cj2./(vp1.*vs2));
	H=a-(d.*ct2.*cj1./(vp2.*vs1));
	D=(E.*F)+(G.*H.*p.^2);
	Rpp=( (((b.*ct./vp1)-(c.*ct2./vp2)).*F)  - ...
            ((a+(d.*ct.*cj2./(vp1.*vs2))).*H.*p.^2) ) ./ D;
   case 2,		%Aki & Richard (aprox)
%assuming (angles) i=i1
	Rpp=(0.5.*(1-(4.*p.^2.*vsa.^2)).*Dd./da) + (Dvp./(2.*ct.^2.*vpa)) - ...
       	  (4.*p.^2.*vsa.*Dvs);
   case 3,		%Shuey
	poi1=((0.5.*(vp1./vs1).^2)-1)./((vp1./vs1).^2-1);
	poi2=((0.5.*(vp2./vs2).^2)-1)./((vp2./vs2).^2-1);
	poia=(poi1+poi2)./2;   Dpoi=(poi2-poi1);
	Ro=0.5.*((Dvp./vpa)+(Dd./da));
	Bx=(Dvp./vpa)./((Dvp./vpa)+(Dd./da));
	Ax=Bx-(2.*(1+Bx).*(1-2.*poia)./(1-poia));
	Rpp= Ro + (((Ax.*Ro)+(Dpoi./(1-poia).^2)).*sin(t).^2) + ...
	         (0.5.*Dvp.*(tan(t).^2-sin(t).^2)./vpa);
   case 4,		%Shuey linear
	A=0.5.*((Dvp./vpa)+(Dd./da));
	B=(-2.*vsa.^2.*Dd./(vpa.^2.*da)) + (0.5.*Dvp./vpa) - ...
	  (4.*vsa.*Dvs./(vpa.^2));
	Rpp=A+(B.*sin(t).^2);
   
    case 5, %Wiggins 1983
	A=0.5.*((Dvp./vpa)+(Dd./da));
    C = 0.5*(Dvp./vpa);
    B = C -4*(vsa./vpa).^2*(Dvs./vsa) - 2*(vsa./vpa).^2*(Dd./da);
    Rpp = A+B*sin(t).^2 +C*tan(t).^2.*sin(t).^2; 

    case 6, %Gidlow et al. 1992, Fatti et al., 1994
	a1 = (1+tan(t).^2);
    b1 = 8*(vsa./vpa).^2*sin(t).^2;
    c1 = 0.5*tan(t).^2-2*(vsa./vpa).^2*sin(t).^2;
    Rpp = a1*Dip./(2*ipa) - b1*Dis./(2*isa) - c1*Dd./da; 

    otherwise,	
       
       
end

if nargout==0
plot(ang,Rpp)
end;
