// Armor reduces damage by the fraction armor / (100 + armor):
// 50 armor removes a third, 100 armor removes half, 300 armor removes three quarters.
// The result is never zero, so no unit becomes immune.
double reduceDamageByArmor(double damage, double armor) => damage * 100 / (100 + armor);
