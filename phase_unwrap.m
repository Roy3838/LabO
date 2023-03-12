%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Unwrapping phase based on Ghiglia and Romero (1994) based on weighted and unweighted least-square method
% URL: https://doi.org/10.1364/JOSAA.11.000107
% Inputs:
%   * psi: wrapped phase from -pi to pi
%   * weight: weight of the phase (optional, default: all ones)
% Output:
%   * phi: unwrapped phase from the weighted (or unweighted) least-square phase unwrapping
% Author: Muhammad F. Kasim (University of Oxford, 2016)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x = 1:100;
y = 1:100;
[x_l, y_l] = meshgrid(x, y);
z = x_l/5 + y_l/5;

z = mod(z, 2*pi) - pi;

z = phase_unwraps(z);

surf(x_l, y_l, z)


function phi = phase_unwraps(psi)
    if (nargin < 2) % unweighted phase unwrap
        % get the wrapped differences of the wrapped values
        dx = [zeros([size(psi,1),1]), wrapToPi(diff(psi, 1, 2)), zeros([size(psi,1),1])];
        dy = [zeros([1,size(psi,2)]); wrapToPi(diff(psi, 1, 1)); zeros([1,size(psi,2)])];
        rho = diff(dx, 1, 2) + diff(dy, 1, 1);     
        phi = solvePoisson(rho);

    end
end

function phi = solvePoisson(rho)
    % solve the poisson equation using dct
    dctRho = dct2(rho);
    disp(dctRho)
    [N, M] = size(rho);
    [I, J] = meshgrid([0:M-1], [0:N-1]);
    dctPhi = dctRho ./ 2 ./ (cos(pi*I/M) + cos(pi*J/N) - 2);
    dctPhi(1,1) = 0; % handling the inf/nan value
    
    % now invert to get the result
    phi = idct2(dctPhi); % este we esta dificil
    
end
