function [A_hex] = load_jacobian_binary_in_steps(filename, id, Mesh)

  fid = fopen(filename,'r');
  % if standard reading is not the correct format for a given binary
  % file, activate the following:
  %fid = fopen(filename,'r','ieee-be');
  
  magicstr = char(fread(fid,3,'char'))';
  if ~isequal(magicstr,'DJM')
    error('read magicstr doe not indicate Dune Sparse Matrix!');
  end;

  magicint = fread(fid,1,'int');
  magicdouble = fread(fid,1,'double');
  
  if (magicint~=111) | (magicdouble~=111.0)
    error(['magic numbers not read correctly, change the binary format in' ...
	   ' this reading routine!!']);
  end;
  
  ncols = fread(fid,1,'int');
  nrows = fread(fid,1,'int');
  %ncols_hex = 2805;
  
  disp(['generating ',num2str(nrows),'x',num2str(ncols),' matrix.']);
  A_hex = [];
  BV1 = [];
 
  n_meas = 73;
  for i =1:nrows/n_meas
     v = fread(fid,n_meas*ncols,'double');
     A_temp = reshape(v, ncols, n_meas); 
     A_temp = A_temp';
     A_temp(:,id) = A_temp;
     A_hex_temp = jacobian_hexagoniser(A_temp,Mesh);
     A_hex = [A_hex; A_hex_temp];
     
%    
     
     disp(['finished loop ', num2str(i), 'out of ' num2str(nrows/n_meas)]);
  end;
  
%   
  eofstr = char(fread(fid,3,'char'))';
  if ~isequal(eofstr,'EOF')
    error('read eofstr does not indicate end of binary file!');
  end;

  fclose(fid);
