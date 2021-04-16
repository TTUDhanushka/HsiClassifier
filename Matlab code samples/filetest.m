%% Writing a file

fid = fopen('myfile_3.txt', 'w');

data = [1, 11, 21, 32, 46, 53, 67, 77, 83, 95, 102, 119];
nbytes = fprintf(fid, '%3.2f \n', data)
fclose(fid);

%% Reading a file to mat.

fid = fopen('myfile_3.txt');

tline = fgetl(fid);

count = 0;
vec = zeros(25, 1);

while ischar(tline)
    count = count + 1;
    vec(count) = str2num(tline);
    tline = fgetl(fid);
end

fclose(fid);