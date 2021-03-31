
/* AQUI VA CON CAMELCASE*/
CREATE TABLE requests(
  number VARCHAR(11) NOT NULL PRIMARY KEY,
  creationDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  type VARCHAR(9) NOT NULL,
  typeNumber tinyint NOT NULL,
  customer VARCHAR(25) NOT NULL,
  requiredCorrectiveAction VARCHAR(30),
  riskAnalysis TEXT,
  rpnBefore SMALLINT,
  rpnAfter SMALLINT,
  originalRisk VARCHAR(7) NOT NULL,
  currentRisk VARCHAR(7) NOT NULL,
  riskWithActions VARCHAR(7) NOT NULL,
  riskDescription TEXT NOT NULL,
  requiresManager BIT NOT NULL DEFAULT 0,
  status VARCHAR(10) NOT NULL DEFAULT 'approving',
  area VARCHAR(30),
  oldNumber VARCHAR(11) DEFAULT '',
  originator VARCHAR(30) NOT NULL
);

CREATE TABLE users(
  username VARCHAR(30) NOT NULL PRIMARY KEY,
  name VARCHAR(60) NOT NULL,
  email VARCHAR(50) NOT NULL,
  password VARCHAR(30) NOT NULL,
  position VARCHAR(40)
)

CREATE TABLE authorizations(
  manager VARCHAR(30) NOT NULL,
  request VARCHAR(11) NOT NULL,
  signed VARCHAR(9) NOT NULL DEFAULT 'pending',
  date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
)

CREATE TABLE actions(
  id INT IDENTITY(1,1) PRIMARY KEY,
  description TEXT NOT NULL,
  date DATE,
  signed VARCHAR(9) NOT NULL DEFAULT 'pending',
  responsable VARCHAR(30) NOT NULL,
  request VARCHAR(11) NOT NULL
)

CREATE TABLE waivers(
  id INT IDENTITY(1,1) PRIMARY KEY,
  currentSpecification TEXT,
  requiredSpecification TEXT NOT NULL,
  reason TEXT NOT NULL,
  request VARCHAR(11) NOT NULL
)

CREATE TABLE parts(
  id INT IDENTITY(1,1) PRIMARY KEY,
  customerPN VARCHAR(25),
  interplexPN VARCHAR(25),
  request VARCHAR(11) NOT NULL
)

CREATE TABLE expiration(
  id INT IDENTITY(1,1) PRIMARY KEY,
  quantity INT,
  specification VARCHAR(7),
  startDate DATE,
  endDate DATE,
  request VARCHAR(11) NOT NULL
)


CREATE TABLE externalAuthorization(
  id INT IDENTITY(1,1) PRIMARY KEY,
  title VARCHAR(40),
  comment TEXT, 
  name VARCHAR(40),
  dateSigned DATE,
  request VARCHAR(11) NOT NULL
)

CREATE TABLE remarks(
  id INT IDENTITY(1,1) PRIMARY KEY,
  comment TEXT,
  date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status VARCHAR(10) NOT NULL DEFAULT 'sent',
  manager VARCHAR(30) NOT NULL,
  request VARCHAR(11) NOT NULL,
)

ALTER TABLE remarks
ADD CONSTRAINT FK_remark_originator
FOREIGN KEY (manager) REFERENCES users(username) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE remarks
ADD CONSTRAINT FK_remark_request
FOREIGN KEY (request) REFERENCES requests(number) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE requests
ADD CONSTRAINT FK_originator
FOREIGN KEY (originator) REFERENCES users(username) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE actions
ADD CONSTRAINT FK_responsable
FOREIGN KEY (responsable) REFERENCES users(username) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE actions
ADD CONSTRAINT FK_action_request
FOREIGN KEY (request) REFERENCES requests(number) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE authorizations 
ADD CONSTRAINT PK_auth
PRIMARY KEY CLUSTERED(manager,request) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE authorizations
ADD CONSTRAINT FK_manager
FOREIGN KEY (manager) REFERENCES users(username) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE authorizations
ADD CONSTRAINT FK_auth_request
FOREIGN KEY (request) REFERENCES requests(number) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE waivers
ADD CONSTRAINT FK_waiver_request
FOREIGN KEY (request) REFERENCES requests(number) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE parts
ADD CONSTRAINT FK_parts_request
FOREIGN KEY (request) REFERENCES requests(number) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE expiration
ADD CONSTRAINT FK_exp_request
FOREIGN KEY (request) REFERENCES requests(number) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE externalAuthorization
ADD CONSTRAINT FK_ext_auth_request
FOREIGN KEY (request) REFERENCES requests(number) ON DELETE CASCADE ON UPDATE CASCADE;