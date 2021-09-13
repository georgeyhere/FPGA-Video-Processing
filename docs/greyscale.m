
r_error = [];
g_error = [];
b_error = [];
x       = [];

% decimal  16 - 240
for i = 16:240
	x(i) = i;

	r = uint8(i);
	g = uint8(i);
	b = uint8(i);

	g_r = bitsra(r,2) + bitsra(r,5) + bitsra(r,6);
	g_g = bitsra(g,1) + bitsra(g,4) + bitsra(g,5);
	g_b = bitsra(b,3);

	r_ref = i;
	g_ref = i;
	b_ref = i;

	g_r_ref = 0.299*r_ref;
	g_g_ref = 0.587*g_ref;
	g_b_ref = 0.114*b_ref;

	r_error(i) = abs((g_r - g_r_ref)/ g_r_ref) * 100;
	g_error(i) = abs((g_g - g_g_ref)/ g_g_ref) * 100;
	b_error(i) = abs((g_b - g_b_ref)/ g_b_ref) * 100;
end

figure('Name', 'Red Error');
plot(x, r_error);

figure('Name', 'Green Error');
plot(x, g_error);

figure('Name', 'Blue Error');
plot(x, b_error);