import 'dart:convert';

import 'package:alipay_kit/src/crypto/rsa.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('smoke test - rsa pkcs1', () {
    const String privateKey =
        'MIIEowIBAAKCAQEA7NIOT2OterfDcmWB4GJEgMYBiQ71Ezh6eRwualxN2A5CkbupMK5Lvh40MddQEv/0L2AV0OdUbl1gRPaAiIFzZVwAdMpTmaf65m4HgI59mBaYWNF14ApHJZkOlEgpvX+TxJfP59on8hMKm1/WBjj/HwtTfnZUUVSP0dFyzy4c5Om/a/fAfGLcH460aDOFrZUfvL09BJf/EVbaW4FtfQ12MF1DwSaxHT7dfi5uq7/w+ZKlUxQ3+sdxcSLbn8OU1J9McUaLzQUINJyEnaT2mCuKW0qYrwlApBCxbCpOUXjL4EfgpNqbDtdge/SCVwmnrhdEu5K7MPegrIHIq53bJGODpwIDAQABAoIBADxg7d8V1dQU6BLRiIRx6W8/jIKqOpe07ZzVL4xUjlBIinZndyJ/PbZyMvKGJ9dARLyTbdx+LkuZKQNMKccj4gz0oPUl5JyndFOtt+Hx8lmFYUA73ybI2Azg8hOiNmonDcCwyAQf3dFdQ3YLwCCEBZ+fnqD+gE7gFW70TKY/5oQCCwsTptnb8rHq6NMtRZ2vkRUXRpMqc9U9GPP9HEJswV+3ynXx7c8eqewnCPn9zA7wYAY2lgKW48IovaAUmahDW/ABz5C3FYO7d7F4AoRhqBox72BgiJkVdeIjb/T7e2Q94A8GvG4IOzUq58hoYHk1olIopVMZxVUzsrZ8l593F1ECgYEA9s/D4t5KkrkrBHL7msfRavOr5ayoGV9B6deH292xJGMW6vy9PhpW+9wIOzYCuOiXPEjw5pDATgzdL7ib9WzLJesM6IJBuK09P/Ita+UWgUML/KpM/9l91fv1ZV9eGkmjvQoxizeAWbR/0Qmskbx6c6BuPTKgFCc+1aiWvIbkep8CgYEA9aMSNNUpdAKMRt6Gw1bQ4sjZBqfpqV2t01+d8ehF//MJ6utKdV67re1z+AduSLWGHNa936rx4fBz0mhWtVjzodp6yidQuIL9lv2vOAVeejZpRRjiS7StzrZvAYuB78/E97IHN+DzktqLTqkG97ypR7HDv1eCXVzYEhhxJ7cOYfkCgYAPKXBFLZazMMDdwxqFxaStx05WC6c/98Qa02y7KwFI1PWBdglCGWgijL/Ms2KzbUZtI6X45AeMQ+oKlnKuPwKzz565Ydcbuzi6BuyXZjlds3q3CNc2GGxMiu/mTFeBkeiHImssvDocSKRZeRiq00NKex6Kj+OZmVeY1IR+DGNYzQKBgQCsd53t6Ikdgjh5/f5DIy6xPPJcoQMHvtWwpt8gHcUga8XX4vK5rBU8jo+xY45EkOekUgapB76jtA+ueUIAPH97cgpq6+XaV2a0YFRpkiN+zbtmH42sOCUdEaypOgm2lnwmqiI1UsXSo43SYg2ZXibBRwg4zbmj0e+H7Q9uIjKACQKBgACwd1oIxcJfgCvKfSoxwjMQeLtQ4k3CSd5hwxoIZVoF1E5UYNPJJlJ+MGnjYtK1EfLEf1Tj8K1ylBx86i7SJ2iOfFiWXrsaB0o/9d1c5IrJ7/b8ru7qSLnu5fwHzPCF6hbl+vjySaqASbo4YbwJSdmzGo3ScdMVcGJb6t0E4Jo0';
    const String publicKey =
        'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA7NIOT2OterfDcmWB4GJEgMYBiQ71Ezh6eRwualxN2A5CkbupMK5Lvh40MddQEv/0L2AV0OdUbl1gRPaAiIFzZVwAdMpTmaf65m4HgI59mBaYWNF14ApHJZkOlEgpvX+TxJfP59on8hMKm1/WBjj/HwtTfnZUUVSP0dFyzy4c5Om/a/fAfGLcH460aDOFrZUfvL09BJf/EVbaW4FtfQ12MF1DwSaxHT7dfi5uq7/w+ZKlUxQ3+sdxcSLbn8OU1J9McUaLzQUINJyEnaT2mCuKW0qYrwlApBCxbCpOUXjL4EfgpNqbDtdge/SCVwmnrhdEu5K7MPegrIHIq53bJGODpwIDAQAB';
    // --- sha1 ---

    final RsaSigner sha1RsaSigner = RsaSigner.sha1Rsa(
        '-----BEGIN RSA PRIVATE KEY-----\n$privateKey\n-----END RSA PRIVATE KEY-----');
    expect(
      base64.encode(
          sha1RsaSigner.sign('aaa=bbb&ccc=ddd&sign_type=RSA'.codeUnits)),
      equals(
          'MElKG6FEvNP28ef6pFcH8cs6UoVgyaN1nGE4aMZzpbYcVhcmQfXJdMCzwv17P9MuAUWnRNO9dZVdyGNM47ZHo6QDjkj2HFso8GvA0Gwd3dWY5hUFjkwcErxe7ABC9wYtZR+9xqKphDrs1B4PT/CEnbk/umYzrV2ckwNHyul7RKa0sgjtpi0OBLiQ2NIm8oj2JkmZvkDNZuGCCJOABmitK1/+8gnsCf4JB57MZDha15Cll797e/cIoVF7eczbpGYJW06HDY0sP1+RVyhOmWV8vXTN+cYOMQh9tNE0rdZG4I10Hb6OxrVSbMODN9CSXlw40NxsLaakET+QiZMebR6ZvQ=='),
    );

    final RsaVerifier sha1RsaVerifier = RsaVerifier.sha1Rsa(
        '-----BEGIN PUBLIC KEY-----\n$publicKey\n-----END PUBLIC KEY-----');
    expect(
      sha1RsaVerifier.verify('aaa=bbb&ccc=ddd&sign_type=RSA'.codeUnits,
          sha1RsaSigner.sign('aaa=bbb&ccc=ddd&sign_type=RSA'.codeUnits)),
      equals(true),
    );

    // --- sha256 ---

    final RsaSigner sha256RsaSigner = RsaSigner.sha256Rsa(
        '-----BEGIN RSA PRIVATE KEY-----\n$privateKey\n-----END RSA PRIVATE KEY-----');
    expect(
      base64.encode(
          sha256RsaSigner.sign('aaa=bbb&ccc=ddd&sign_type=RSA2'.codeUnits)),
      equals(
          'w3VvL+9rd0cXGz9whyuvLKYNlyeqhpQDVuk7oiN4cX8RjAKc/YAkZMgT7nWeHLXUNBw3KnWWy4e1HYaDowA9aIsyNuQq54lzGdnb89S7tA7EB7zhG65M+UbAz9juHNG4AyA/xJ1MKxrmJpJZ4UBEXuDo537l9zM95LlslIrM+g9UpeNe52oZtTJBtwYsR4FbKYY5dy5dEXVzsje1ZNATaOcohzPc9RhGHvusdLq+FMDU7ZrUdaqX+bWLm0nlLZOaKlh6CrR/XchiU7un6gkrjEwQTZ7jE6U4aptMwc1VmaPOgiQPM8mt5lkWG8rTYaX/LSLD0lcmXS512Rx0ZOxogw=='),
    );

    final RsaVerifier sha256RsaVerifier = RsaVerifier.sha256Rsa(
        '-----BEGIN PUBLIC KEY-----\n$publicKey\n-----END PUBLIC KEY-----');
    expect(
      sha256RsaVerifier.verify('aaa=bbb&ccc=ddd&sign_type=RSA2'.codeUnits,
          sha256RsaSigner.sign('aaa=bbb&ccc=ddd&sign_type=RSA2'.codeUnits)),
      equals(true),
    );
  });

  test('smoke test - rsa pkcs8', () {
    const String privateKey =
        'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC4/zzSLKzKd1te6zqAXU82222VhqVL1gr8YvJ6iIRc7Vx8l6rX1OyDswoPS8niqSXT/DxgAMvEJ8y231kEGTD2v14Q7c6Qqn4lHvU5edEiMU9exug9yJJuM+7X8mJ7tqP9cwd2XGo4NNaXDw7kWx5tudfY4iYoVpcK3ytnErmw2sgDWPua+8zbCuJRFjQ9ptMbn9mcXC6ixiG33woT7sKH1U1k4eb879GhiSdfDDPqnG1ChFCZRtb5MrQL792NJ+9j6dhcAI0FTi9euSR5W8PV79u4JukZca5GUgAxza2VyyLZkc0Ks/ygPK+RZL1VQyr8IsRaFUxZql3L25TYyqg9AgMBAAECggEAQsaexZ6qoEqFCLYP39XOihaab6ayc7VHMeLlc6VjYcer4q08Vbvdw4wUzYCl1tMHfIVHpb+jzaIwGrJ0By6wpeBdq+6q6T0hW3TZP23hN15lL+jMW8DSWkUUqY4sTkuW1h13TBn/nVo1O0GMNpFNYn36k6bN7zGSQ7JakFIKBPPUxnNgrwyf7T/oXTFBL6qrWYhDHwsFbTQX2UuLiF7+I4bJhDuZt39b31/h6EqzeVi9b31OEmpMKojPBDv2VzZ5Wun2SO9bBeiiSSUIuiU1sgOWBPEB6O5TMttNvmyA8GQa4HiTlYMz/rkmwwwgdfh4T/lSiDV9+Vd63xRj8eKqYQKBgQD+dzpZV7cILAp7XtUh6axaZR8iuzYjjnpaQmxCrBBCfl16lgCmJhspvxHZnZgurLL96JeU6hYtGck3VDpxPKVtSHPybxQwEysK236B2V6AEwLkVKEHB03g35FxHYo14x0mjUkfF7Q8NrmnPtELmYv7Z03OZHkFlWSSg12Jgc6fvwKBgQC6HMiWorPapzYwyD+H4si+yuUtO+YEPMvatN7bnymppuSt5RL4FVNdL02lzL6bUVhvsfDqQ6kws/wKYpLwTksYNkM9P14UKqFzy5zKSOr/zx5mXwgaaOJ7DnZx4outaFgntW8pQGjWHxbBX3H6mydRbVYaN6qUsjTHqaL6kCN3AwKBgQC9QSOOayRf2ZF6LA/MByT+nhLIHACp9T+efaRS+fGl4qHXmFSnPdQZ+ldmSEV1AVCmcyS5xlfz9yemFOjaa0aFvsstVdvn3Xm3u4OdQ3N7Qah29VJGDfKn+t8LB/NRHLcDgzUNAO41kmYFszx6qhpoQm6lwCgaNP/1z+nzaS2ptQKBgGyRk/ZD7bV06+jjOCR2CHM8exq7IYCBUs4/yu3FWJGOOUK0Ki+siRgIGzzIRrzmZDesTwTp+Y3ewP3x6RPkKGx0Yx8cky4ifFLHiax7gxM9aNeBQoHdg5kTo8blyGOdRifL8I/Y8g9OzYB6xEvULMiUhrD+njTmDGIZNGkEopuvAoGAXE+WA8GxSruKR9SziyaZxnGB1ggTDOT5qe8eeQnFpsfxU4ZAICrWB7Glezy0YyOXpRIxluUYjQdMkDQBz8913r/eYFdGw68z3iQY1xMkXMcy7ikeZ/VZjkQHVwbUplDH4ESGPoUjE32MHzRX9oiQkyWFK4x0qFu9gdYKb1tRTLw=';
    const String publicKey =
        'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAuP880iysyndbXus6gF1PNtttlYalS9YK/GLyeoiEXO1cfJeq19Tsg7MKD0vJ4qkl0/w8YADLxCfMtt9ZBBkw9r9eEO3OkKp+JR71OXnRIjFPXsboPciSbjPu1/Jie7aj/XMHdlxqODTWlw8O5FsebbnX2OImKFaXCt8rZxK5sNrIA1j7mvvM2wriURY0PabTG5/ZnFwuosYht98KE+7Ch9VNZOHm/O/RoYknXwwz6pxtQoRQmUbW+TK0C+/djSfvY+nYXACNBU4vXrkkeVvD1e/buCbpGXGuRlIAMc2tlcsi2ZHNCrP8oDyvkWS9VUMq/CLEWhVMWapdy9uU2MqoPQIDAQAB';

    // --- sha1 ---

    final RsaSigner sha1RsaSigner = RsaSigner.sha1Rsa(
        '-----BEGIN PRIVATE KEY-----\n$privateKey\n-----END PRIVATE KEY-----');
    expect(
      base64.encode(
          sha1RsaSigner.sign('aaa=bbb&ccc=ddd&sign_type=RSA'.codeUnits)),
      equals(
          'BChBZy3vSJZxv3iTCfWpimtrpEyxkSVJT7mchct6NHyV6T/MD2yThVbtu7cKeMZNUnINomoSbek8Pxx7iXHCOO4oUhTXTaxi/QRUEC8V67Hv0nLEjSOd+7B2JPTuRyDPgBsnTaztzA2PeynXhw+LdFYZXHJHtmKCebYePCtxQBolgXnojAxGeBr0jDhara7B8da5gWhMeGguY9SdpqMrliGQc7JbAkuyZ2aMWMny8Q3rNWBUQLMQ5YJKn1K7nZJi24bOEz+CoPkjhY7E4g3casUN05+vBV/p73UIMZhYgQ4p4gj2ONM/K0sbPJyDEoSXYJCOhK0e4inHuF76dzFr6Q=='),
    );

    final RsaVerifier sha1RsaVerifier = RsaVerifier.sha1Rsa(
        '-----BEGIN PUBLIC KEY-----\n$publicKey\n-----END PUBLIC KEY-----');
    expect(
      sha1RsaVerifier.verify('aaa=bbb&ccc=ddd&sign_type=RSA'.codeUnits,
          sha1RsaSigner.sign('aaa=bbb&ccc=ddd&sign_type=RSA'.codeUnits)),
      equals(true),
    );

    // --- sha256 ---

    final RsaSigner sha256RsaSigner = RsaSigner.sha256Rsa(
        '-----BEGIN PRIVATE KEY-----\n$privateKey\n-----END PRIVATE KEY-----');
    expect(
      base64.encode(
          sha256RsaSigner.sign('aaa=bbb&ccc=ddd&sign_type=RSA2'.codeUnits)),
      equals(
          'RseGCyzKFhD6Gz1NqbF7HAHG/O8Sq7vUEfxbJZTQU4ihpzgj5WtnqBM5l/9z5nyxoQrnqt/et+LpmS+tgcXr1gLx6SG8LSXjaBgEjCa3gkcCihkoMCNOYjmkFCqxMz1qDEPbgZAuuvHGHd/DvdojfdqQ58p/Bo+Z5sH1bSbdDAhu+J0TOSM8NrXgB/nY8W8mr8S/LKYqaukClY/01j41/ppJ22DGN+jNZDt1Q90CR9D15uoAggupzyJuC1Emyax4ASz2kN7LXlsAxdRzk6oZy2a1r8dd+g7dBYgxXVaiBMAYsyK3XrIx1GWu+DzNFEnqJ/+JHyCso2laPLZ9JDOwHQ=='),
    );

    final RsaVerifier sha256RsaVerifier = RsaVerifier.sha256Rsa(
        '-----BEGIN PUBLIC KEY-----\n$publicKey\n-----END PUBLIC KEY-----');
    expect(
      sha256RsaVerifier.verify('aaa=bbb&ccc=ddd&sign_type=RSA2'.codeUnits,
          sha256RsaSigner.sign('aaa=bbb&ccc=ddd&sign_type=RSA2'.codeUnits)),
      equals(true),
    );
  });
}
