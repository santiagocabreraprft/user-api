function fn() {
  var Faker = Java.type('com.github.javafaker.Faker');
  var faker = new Faker();

  var config = {
    baseUrl: 'http://localhost:8080/api',
    faker: faker
  };

  return config;
}