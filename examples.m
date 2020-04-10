%% Examples
nodos = [0 0;1 0;2 0;0 1;1 1;0 2];
elementos = [1 3 6 2 5 4];
stress = rand(size(elementos))*1e8;
[Nnod, Ndim] = size(nodos);
[Nelem, Nnodporelem] = size(elementos);

% Definicion de cargas y condiciones de borde
Ndofpornod = 2;
dof = Ndofpornod * Nnod;
R =    zeros(dof,1);
fixed = false(dof,1);
fixed([1 2 5 6]) = true; % Fijo dos costados
R([11 12]) = [30 45];

% BANDPLOTX
figure(1);
bandplotx(elementos,nodos,stress)
title('Bandplot ejemplo simple')
figure(2)
subplot(2,2,1)
title('Bandplot ejemplos con parametros')
bandplotx(elementos,nodos,stress,'NameNodes',true,'NameElements',true,'FaceOpacity',0)
subplot(2,2,2)
bandplotx(elementos,nodos,stress,'Coloring','adina','LineColor',[0 1 1])
subplot(2,2,3)
bandplotx(elementos,nodos,stress,'Coloring',hot,'NTicks',4,'FmtLegend','%1.2E Pa')
subplot(2,2,4)
bandplotx(elementos,nodos,stress,'FmtLegend','%0.2f','NColors',100,'FaceOpacity',.6)

% DOMAINPLOT
figure(3)
subplot(2,1,1)
domainplot(nodos, fixed, R)
subplot(2,1,2)
domainplot(nodos, fixed, R, 'NodeStyle','g*')

