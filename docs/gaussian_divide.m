error = [];
x     = [];

for i = 1:2048
	x(i) = i;
    index = uint32(i);

	shiftResult = bitsra(index,4);
	refResult = index/16;

	error(i) = abs((shiftResult-refResult)/refResult)*100;

end

figure('Name', 'Error');
plot(x, error);
