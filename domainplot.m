function [] = domainplot(nodos, fix, R, varargin)
% DOMAINPLOT(NODES, FIXITY, LOADS, OPTIONS)  plots 3D or 2D node
% matrix whose columns are x, y, z values. Plots border conditions
% and vector loads.
%
% DOMAINPLOT(NODES, FIXITY, LOADS, NAME, VALUE) configures
% optional plotting options
%
% 'NodeStyle' - Scatter marker style for nodes. Default is 'k.' (black dot)
% 'LoadColor' - Load vector color. Default is rgb vector [1 0 0]  (red)
%
% Example: DOMAINPLOT(NODES, FIX , F)

Nparam = nargin-3;
if mod(Nparam,2)~=0 && Nparam > 0 %
    error('Se deben pasar los parametros en grupos de 2, nombre y luego valor')
end
%% Parameter setting
NodeStyle = 'k.';
LoadColor = [1 0 0];
for arg = 1:2:Nparam
    switch varargin{arg}
        case {'NodeStyle'}
            NodeStyle = varargin{arg+1};
        case {'LoadColor'}
            LoadColor = varargin{arg+1};
        otherwise
            error('Unknown name of parameter %s',varargin{arg})     
    end
end
%% Continue with code
[Nnod, Ndim] = size(nodos);
dof = length(R);
Ndn = dof / Nnod; % Numero de dof por nodo
giros = false(Ndn,1);
if Ndim ~= Ndn
    giros(Ndim+1:Ndn) = true; % Los primeros son por convencion desplazamientos
end
%% Tamaño característico para dimensionar grafico de fuerzas
Fmax = 0;
Fxyz = zeros(Nnod,Ndim);
Lc = 0;
for i=1:Ndim
    F = R(i:Ndn:end);
    Fmax = Fmax + F.^2;
    Lc = Lc + (max(nodos(:,i))-min(nodos(:,i)))^2;
    Fxyz(:,i) = F;
end
Fmax = max(sqrt(Fmax));
Lc = sqrt(Lc);
escala = (Lc/Fmax); %Magnificacion de desplazamientos
Fxyz = escala*Fxyz;
n2d = @(n) repmat(n*Ndn,Ndn,1) - (Ndn-1:-1:0)'; % forma generalizada

%% Sigo con el resto
graphUVW = false(Nnod,1);
graphGIRO = false(Nnod,1);
graphFORCE = false(Nnod,1);
graphNOD = true(Nnod,1);
for n=1:Nnod
    meindof = n2d(n);
    if sum(fix(meindof(~giros)))>0
        graphUVW(n)=true;
    end
    if sum(fix(meindof(~giros)))>0
        graphGIRO(n)=true;
        if sum(fix(meindof)) == Ndn
            graphNOD(n) = false; % desaparezco el nodo, es empotrado
        end
    end
    if sum( meindof(~giros)~=0 )>0
        graphFORCE(n)=true;
    end
end

%% 3D plot
thisAxes = gca;
if Ndim == 3
    scatter3(thisAxes, nodos(graphNOD,1),nodos(graphNOD,2),nodos(graphNOD,3),NodeStyle)
    hold on
    xlabel(thisAxes,'x')
    ylabel(thisAxes,'y')
    zlabel(thisAxes,'z')
    scatter3(thisAxes,nodos(graphUVW,1),nodos(graphUVW,2),nodos(graphUVW,3),80,[0.3010 0.7450 0.9330],'+')
    if sum(giros)>0
        scatter3(thisAxes,nodos(graphGIRO,1),nodos(graphGIRO,2),nodos(graphGIRO,3),80,[0.4010 0.8450 0.8330],'x')
    end
    quiver3(thisAxes,nodos(graphFORCE,1), nodos(graphFORCE,2), nodos(graphFORCE,3), Fxyz(graphFORCE,1),Fxyz(graphFORCE,2),Fxyz(graphFORCE,3) )
    daspect(thisAxes,[1 1 1])
    return
end

%% 2D plot
scatter(thisAxes,nodos(graphNOD,1),nodos(graphNOD,2),NodeStyle)
hold on
xlabel(thisAxes,'x')
ylabel(thisAxes,'y')
scatter(thisAxes,nodos(graphUVW,1),nodos(graphUVW,2),80,[0.3010 0.7450 0.9330],'+')
if sum(giros)>0
    scatter(thisAxes, nodos(graphGIRO,1),nodos(graphGIRO,2),80,[0.4010 0.8450 0.8330],'x')
end
quiver(thisAxes, nodos(graphFORCE,1), nodos(graphFORCE,2), Fxyz(graphFORCE,1),Fxyz(graphFORCE,2),'Color', LoadColor)
daspect(thisAxes, [1 1 1])
hold on
end

