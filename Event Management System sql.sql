
CREATE TYPE "event_type_t" AS ENUM ('conference', 'concert');

CREATE TABLE IF NOT EXISTS "event" (
	"event_id" serial NOT NULL UNIQUE,
	"name" varchar2(225) NOT NULL,
	"description" varchar2(225),
	"event_type" event_type_t NOT NULL,
	"start_date" date NOT NULL,
	"end_date" date NOT NULL,
	"budget" int NOT NULL,
	"revenue" int NOT NULL,
	"created_at" TIMESTAMPTZ NOT NULL,
	PRIMARY KEY("event_id")
);


CREATE TABLE IF NOT EXISTS "venue" (
	"venue_id" serial NOT NULL UNIQUE,
	"name " varchar2(225) NOT NULL,
	"location" varchar2(225) NOT NULL,
	"capacity" int NOT NULL,
	"created_at" TIMESTAMPTZ NOT NULL,
	PRIMARY KEY("venue_id")
);


CREATE TABLE IF NOT EXISTS "event_venue" (
	"event_id" serial NOT NULL UNIQUE,
	"venue_id" int NOT NULL,
	"created_at" TIMESTAMPTZ NOT NULL,
	PRIMARY KEY("event_id", "venue_id")
);


CREATE TABLE IF NOT EXISTS "session" (
	"session_id" serial NOT NULL UNIQUE,
	"event_id" int NOT NULL,
	"start_date" date NOT NULL,
	"end_date" date NOT NULL,
	"created_at" date NOT NULL,
	PRIMARY KEY("session_id")
);


CREATE TYPE "ticket_type_t" AS ENUM ('Gold', 'Silver', 'bronze');

CREATE TYPE "payment_status_t" AS ENUM ('paid', 'unpaid', 'waiting for status');

CREATE TABLE IF NOT EXISTS "attendee" (
	"attendee_id" serial NOT NULL UNIQUE,
	"name" varchar2(225) NOT NULL,
	"email" varchar2(225) NOT NULL UNIQUE,
	"ticket_type" ticket_type_t NOT NULL,
	"payment_status" payment_status_t NOT NULL,
	PRIMARY KEY("attendee_id")
);


CREATE TABLE IF NOT EXISTS "event_attendee" (
	"event_id" serial NOT NULL UNIQUE,
	"attendee_id" int NOT NULL,
	PRIMARY KEY("event_id", "attendee_id")
);


CREATE TABLE IF NOT EXISTS "session_attendee" (
	"session_id" serial NOT NULL UNIQUE,
	"attendee_id" int NOT NULL,
	PRIMARY KEY("session_id", "attendee_id")
);


CREATE TYPE "ratings_t" AS ENUM ('good', 'average', 'bad');

CREATE TABLE IF NOT EXISTS "feedback" (
	"feedback_id" serial NOT NULL UNIQUE,
	"attendee_id" int NOT NULL,
	"event_id" int NOT NULL,
	"ratings" ratings_t NOT NULL,
	"comments" text(65535),
	"created_at" TIMESTAMPTZ NOT NULL,
	PRIMARY KEY("feedback_id")
);


CREATE TYPE "level_t" AS ENUM ('gold', 'silver');

CREATE TABLE IF NOT EXISTS "sponsor" (
	"sponsor_id" serial NOT NULL UNIQUE,
	"name" varchar2(225) NOT NULL,
	"email" varchar(255) NOT NULL,
	"level" level_t NOT NULL,
	PRIMARY KEY("sponsor_id")
);


CREATE TABLE IF NOT EXISTS "event_sponsor" (
	"event_id" serial NOT NULL UNIQUE,
	"sponsor_id" int NOT NULL,
	"amount" int NOT NULL,
	"agreement" text(65535) NOT NULL,
	"created_at" TIMESTAMPTZ NOT NULL,
	PRIMARY KEY("event_id", "sponsor_id")
);


CREATE TYPE "sales_channel_t" AS ENUM ('online', 'offline');

CREATE TABLE IF NOT EXISTS "ticket" (
	"ticket_id" serial NOT NULL UNIQUE,
	"event_id" int NOT NULL,
	"attendee_id" int NOT NULL,
	"sales_channel" sales_channel_t NOT NULL,
	"seat_number" varchar2(225) NOT NULL,
	"price" int NOT NULL,
	"discount_applied" varchar2(225) NOT NULL,
	PRIMARY KEY("ticket_id")
);


ALTER TABLE "event"
ADD FOREIGN KEY("event_id") REFERENCES "event_venue"("event_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "venue"
ADD FOREIGN KEY("venue_id") REFERENCES "event_venue"("venue_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "event"
ADD FOREIGN KEY("event_id") REFERENCES "session"("event_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "attendee"
ADD FOREIGN KEY("attendee_id") REFERENCES "event_attendee"("attendee_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "session"
ADD FOREIGN KEY("session_id") REFERENCES "session_attendee"("session_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "attendee"
ADD FOREIGN KEY("attendee_id") REFERENCES "session_attendee"("attendee_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "attendee"
ADD FOREIGN KEY("attendee_id") REFERENCES "feedback"("attendee_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "event"
ADD FOREIGN KEY("event_id") REFERENCES "feedback"("event_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "event"
ADD FOREIGN KEY("event_id") REFERENCES "event_sponsor"("event_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "sponsor"
ADD FOREIGN KEY("sponsor_id") REFERENCES "event_sponsor"("sponsor_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "ticket"
ADD FOREIGN KEY("event_id") REFERENCES "event"("event_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "ticket"
ADD FOREIGN KEY("attendee_id") REFERENCES "attendee"("attendee_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;