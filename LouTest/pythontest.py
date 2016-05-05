import matlab.engine

eng = matlab.engine.start_matlab()
print "okay matlab engine called"
testret = eng.interface_test("hi")

eng.quit()
